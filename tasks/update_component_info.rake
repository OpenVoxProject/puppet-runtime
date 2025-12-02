require 'json'

FIRST_TAG = '202501080'.freeze # First tag to include when regenerating
IGNORED_PLATFORMS = %w[aix solaris redhatfips windowsfips el-6 osx sles-11 windows-2012r2 ppc64le armhf i386].freeze
INCLUDED_PROJECTS = %w[agent-runtime openbolt-runtime].freeze

def platforms
  # First item will be a `- Platforms` header. Also exclude
  # any platforms we don't actually build for or have problems parsing.
  `bundle exec vanagon list -l`.split("\n")[1..]
                               .reject { |p| p =~ /(#{IGNORED_PLATFORMS.join('|')})/ }
end

def projects
  # First item will be a `- Projects` header. Also exclude
  # any projects prefixed with '_' as these are not real projects and
  # are shared between projects. Also ignore any projects we don't care
  # about.
  `bundle exec vanagon list -r`.split("\n")[1..]
                               .reject { |p| p.start_with?('_') || p !~ /^(#{INCLUDED_PROJECTS.join('|')})/ }
end

# Sometimes the version is a git ref so extract
# actual version numbers. Fall back to 0 if nothing
# usable is found so everything is comparable.
def parse_version(ver)
  Gem::Version.new(ver.to_s[/\d+(?:\.\d+)+/] || 0)
end

def component_info
  # Build component list with version/ref for each project
  puts `pwd`
  project_data = {}
  projects.each do |project|
    puts "Processing project #{project}"
    project_data[project] = {}

    platforms.each do |platform|
      puts "  #{platform}"
      platform_data = JSON.parse(`bundle exec vanagon inspect #{project} #{platform}`)
      project_data[project][platform] = platform_data.map { |h| [h['name'], h['version'] || h.dig('options', 'ref')] }.to_h
    end
  end

  component_data = project_data.values
                               .flat_map(&:values).flatten    # [{comp1 => ver1}, {comp2 => ver2}, ...]
                               .flat_map(&:to_a)              # [[comp1, ver1], [comp2, ver2], ...]
                               .group_by(&:first)             # { comp1 => [[comp1, ver1], [comp1, ver2], ...], ... }
                               .transform_values do |pairs| # { comp1 => verN, ... }
    pairs.max_by { |_, ver| parse_version(ver) }.last
  end

  { 'components' => component_data, 'projects' => project_data }
end

# We use `vanagon inspect` to get components instead of parsing the
# files directly, so that we can populate a list of components per
# platform, as they can differ between platforms.
namespace :vox do
  desc 'Update component_info.json file with current component versions'
  task :update_component_info, [:tag] do |_, args|
    abort 'You must provide the tag that will be used for this release.' if args[:tag].nil? || args[:tag].empty?

    File.write('component_info.json', '{}') unless File.exist?('component_info.json')
    data = JSON.parse(File.read('component_info.json'))

    data[args[:tag]] = component_info

    # Put the new data on top
    data = data.to_a.rotate(-1).to_h

    File.write('component_info.json', JSON.pretty_generate(data))
    puts "Updated component_info.json with data for tag #{args[:tag]}"
  end

  desc 'Regenerate component_info.json with all tags'
  task :regenerate_component_info do
    # Clone a copy of the repo to avoid messing up the current working dir
    `git clone https://github.com/openvoxproject/puppet-runtime puppet-runtime-tmp`
    begin
      all_data = {}
      Dir.chdir('puppet-runtime-tmp') do
        `git fetch origin --tags --prune --prune-tags`
        `git tag --sort=creatordate | awk '$0=="#{FIRST_TAG}"{seen=1; next} seen'`.split("\n").each do |tag|
          puts "Checking out tag #{tag}..."
          `git checkout #{tag}`
          Bundler.with_unbundled_env do
            `BUNDLER_GEMFILE=./Gemfile bundle install --path .bundle`
            all_data[tag] = component_info
          end
        end
      end
      # Reverse order to latest is on top
      all_data = all_data.to_a.reverse.to_h
      File.write('component_info.json', JSON.pretty_generate(all_data))
      puts 'Regenerated component_info.json with data for all tags.'
    ensure
      FileUtils.rm_rf('puppet-runtime-tmp')
    end
  end
end
