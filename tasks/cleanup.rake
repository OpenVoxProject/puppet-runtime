namespace :vox do
  desc 'Cleanup after puppet-runtime compile'
  task :cleanup, [:platform] do |_, args|
    abort 'You must provide a platform.' if args[:platform].nil? || args[:platform].empty?
    platform = args[:platform]

    if platform =~ /^windows-/
      delete_directory('C:/ProgramFiles64Folder')
    elsif platform =~ /^osx-/
      delete_directory('/opt/puppetlabs')
      delete_directory('/private/etc/puppetlabs')
    else
      delete_directory('/opt/puppetlabs')
      delete_directory('/etc/puppetlabs')
    end
  end
end
