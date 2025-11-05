source ENV['GEM_SOURCE'] || "https://rubygems.org"

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
gem 'vanagon', *location_for(ENV['VANAGON_LOCATION'] || 'https://github.com/openvoxproject/vanagon#main')
gem 'packaging', *location_for(ENV['PACKAGING_LOCATION'] || '~> 0.105')
gem 'rake', '~> 13.0'

group(:development, optional: true) do
  gem 'highline', require: false
  gem 'parallel', require: false
  gem 'colorize', require: false
  gem 'hashdiff', require: false
  gem 'tty-table', require: false
end

group(:release, optional: true) do
  gem 'faraday-retry', '~> 2.1', require: false
  gem 'github_changelog_generator', '~> 1.16.4', require: false
end
