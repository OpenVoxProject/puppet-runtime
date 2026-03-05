source ENV['GEM_SOURCE'] || 'https://rubygems.org'

def location_for(place)
  if place =~ /^((?:git[:@]|https:)[^#]*)#(.*)/
    [{ :git => $1, :branch => $2, :require => false }]
  elsif place =~ /^file:\/\/(.*)/
    ['>= 0', { :path => File.expand_path($1), :require => false }]
  else
    [place, { :require => false }]
  end
end

gem 'artifactory'
gem 'packaging', *location_for(ENV['PACKAGING_LOCATION'] || '~> 0.105')
gem 'rake', '~> 13.0'
gem 'rubocop', '~> 1.86'
gem 'rubocop-rake', '~> 0.7'
gem 'vanagon', *location_for(ENV['VANAGON_LOCATION'] || 'https://github.com/openvoxproject/vanagon#main')
# Need to update the openssl gem on MacOS to avoid SSL errors.
# https://www.rubyonmac.dev/certificate-verify-failed-unable-to-get-certificate-crl-openssl-ssl-sslerror
gem 'openssl', '~> 3' if RUBY_PLATFORM =~ /darwin/

gem 'octokit', '< 11'

group(:development, optional: true) do
  gem 'hashdiff', require: false
  gem 'highline', require: false
  gem 'parallel', require: false
end

group(:release, optional: true) do
  gem 'faraday-retry', '~> 2.1', require: false
  gem 'github_changelog_generator', '~> 1.18', require: false
end
