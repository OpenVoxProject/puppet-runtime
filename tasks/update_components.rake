# frozen_string_literal: true

require 'digest'
require 'json'
require 'octokit'
require 'open-uri'
require 'rake'
require 'rubygems/version'
require 'uri'

COMPONENTS_JSON_GLOB = File.join(File.expand_path('..', __dir__), 'configs', 'components', '*.json')

def github_client
  @github_client ||= Octokit::Client.new(access_token: ENV['GITHUB_TOKEN']).tap do |client|
    client.auto_paginate = true
  end
end

# Extract GitHub owner and repo from a URL string.
# Returns [owner, repo] or nil if not a GitHub URL.
def github_owner_repo(url)
  return nil unless url.to_s =~ %r{github\.com/([^/]+)/([^/\s?#]+)}

  [Regexp.last_match(1), Regexp.last_match(2).sub(/\.git$/, '')]
end

# Normalize a version string by stripping common tag prefixes and
# replacing underscores with .
def normalize_version(tag)
  return nil if tag.nil?

  tag.sub(/\Av(?=\d)/, '')
     .sub(/\Arefs\/tags\/v?/, '')
     .sub(/\Arelease-/, '')
     .sub(/\Aopenssl-/, '')
     .sub(/\Acurl-/, '')
     .gsub('_', '.')
end

# Try to parse a version from a normalized string, returning nil if unparseable.
def try_version(str)
  Gem::Version.new(str)
rescue ArgumentError
  nil
end

def latest_github_release(owner, repo)
  github_client.latest_release("#{owner}/#{repo}")
rescue StandardError => e
  warn "  Warning: could not fetch latest release for #{owner}/#{repo}: #{e}"
  nil
end

# *sighs* this looks a bit complicated. some repos have weird tags like release-$ver or $major_$minor_$patch
# and somme people, like openssl, maintain multiple streams. So the latest tag might not be the highest version
# We do some version comparison to find the actual highest version
def latest_github_tag(owner, repo)
  tags = github_client.tags("#{owner}/#{repo}", per_page: 100)
                      .map { |tag| [tag.name, try_version(normalize_version(tag.name))] }
                      .reject { |_, version| version.nil? || version.prerelease? }
                      .max_by { |_, version| version }

  tags.nil? ? tags : tags.first
end

def current_version(data)
  if data['ref'].to_s =~ %r{refs/tags/(.*)}
    normalize_version(Regexp.last_match(1))
  else
    normalize_version(data['version'])
  end
end

def latest_upstream_tag(owner, repo, ref)
  if ref.nil?
    latest_github_release(owner, repo)&.tag_name || latest_github_tag(owner, repo)
  else
    latest_github_tag(owner, repo)
  end
end

def download_digest(url)
  digest = Digest::SHA256.new

  OpenURI.open_uri(url, 'rb') do |io|
    digest << io.read(1024 * 16) until io.eof?
  end

  digest.hexdigest
end

def updated_release_url(current_url:, current_version:, latest_version:, latest_tag:, release:)
  uri = URI(current_url)
  updated_path = uri.path.sub(%r{(/releases/download/)[^/]+(/)}, "\\1#{latest_tag}\\2")
  updated_path = updated_path.gsub(current_version, latest_version) unless current_version.empty?
  asset_name = File.basename(updated_path)
  release_asset = release&.assets&.find { |asset| asset.name == asset_name }

  return release_asset.browser_download_url if release_asset

  uri.path = updated_path
  uri.to_s
end

def update_component_file(path, latest_tag:, latest_version:)
  data = JSON.parse(File.read(path))
  owner, repo = github_owner_repo(data['url'])
  release = latest_github_release(owner, repo)
  current_ver = current_version(data)
  updated = false

  if data.key?('version') && data['version'] != latest_version
    data['version'] = latest_version
    updated = true
  end

  desired_ref = "refs/tags/#{latest_tag}"
  if data.key?('ref') && data['ref'] != desired_ref
    data['ref'] = desired_ref
    updated = true
  end

  if data['url'].include?('github.com') && data['url'].include?('/releases/download/')
    new_url = updated_release_url(
      current_url: data['url'],
      current_version: current_ver,
      latest_version: latest_version,
      latest_tag: latest_tag,
      release: release
    )

    if new_url != data['url']
      data['url'] = new_url
      updated = true
    end
  end

  digest = download_digest(data['url'])
  data['sha256sum'] = digest

  File.write(path, "#{JSON.pretty_generate(data)}\n") if updated

  { updated: updated, url: data['url'] }
end

def check_component(path)
  name = File.basename(path, '.json')
  data = JSON.parse(File.read(path))

  owner, repo = github_owner_repo(data['url'])

  return { name: name, status: :skip, reason: 'No GitHub URL detected' } unless owner

  current_ver_str = current_version(data)
  current_ver = try_version(current_ver_str)
  latest_tag = latest_upstream_tag(owner, repo, data['ref'])

  return { name: name, status: :error, reason: 'Could not determine latest upstream version' } if latest_tag.nil?

  latest_ver_str = normalize_version(latest_tag)
  latest_ver = try_version(latest_ver_str)

  return { name: name, status: :error, reason: "Could not parse upstream version '#{latest_ver_str}'" } if latest_ver.nil?
  return { name: name, status: :error, reason: "Could not parse current version '#{current_ver_str}'" } if current_ver.nil?

  if latest_ver > current_ver
    { name: name, path: path, status: :outdated, current: current_ver_str, latest: latest_ver_str, tag: latest_tag }
  else
    { name: name, path: path, status: :up_to_date, current: current_ver_str }
  end
end

def component_results
  Dir[COMPONENTS_JSON_GLOB].map { |path| check_component(path) }
end

def print_component_results(results)
  puts "Checking #{results.length} component(s) for updates...\n\n"

  outdated = []
  errors = []
  skipped = []

  results.each do |result|
    print "  #{result[:name]}... "
    $stdout.flush

    case result[:status]
    when :up_to_date
      puts "up to date (#{result[:current]})"
    when :outdated
      puts "OUTDATED: #{result[:current]} -> #{result[:latest]}"
      outdated << result
    when :skip
      puts "skipped (#{result[:reason]})"
      skipped << result
    when :error
      puts "error (#{result[:reason]})"
      errors << result
    end
  end

  puts "\n"

  unless outdated.empty?
    puts '=== Components with available updates ==='
    outdated.each do |result|
      puts "  #{result[:name]}: #{result[:current]} -> #{result[:latest]} (upstream tag: #{result[:tag]})"
    end
    puts ''
  end

  unless errors.empty?
    puts '=== Errors encountered ==='
    errors.each { |result| puts "  #{result[:name]}: #{result[:reason]}" }
    puts ''
  end

  unless skipped.empty?
    puts '=== Skipped (no checkable upstream) ==='
    skipped.each { |result| puts "  #{result[:name]}: #{result[:reason]}" }
    puts ''
  end

  puts 'All components are up to date.' if outdated.empty? && errors.empty?

  { outdated: outdated, errors: errors, skipped: skipped }
end

namespace :vox do
  desc 'Print non-rubygem components with upstream GitHub updates'
  task :print_outdated_components do
    print_component_results(component_results)
  end

  desc 'Update outdated non-rubygem components backed by GitHub releases or tags'
  task :update_outdated_components do
    summary = print_component_results(component_results)

    summary[:outdated].each do |result|
      update_component_file(result[:path], latest_tag: result[:tag], latest_version: result[:latest])
      puts "Updated #{result[:name]} to #{result[:latest]}"
    end

    abort 'One or more components could not be checked.' unless summary[:errors].empty?
    puts 'No component files needed changes.' if summary[:outdated].empty?
  end
end
