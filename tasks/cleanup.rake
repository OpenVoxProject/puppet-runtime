# Deletes a directory and all of its contents
# Using instead of fileutils as MacOS doesn't delete the actual directory
# when using fileutils, just the contents of that directory
def delete_directory(path)
  return unless Dir.exist?(path)

  Dir.foreach(path) do |entry|
    next if entry == '.' || entry == '..'

    full_path = File.join(path, entry)

    if File.directory?(full_path)
      delete_directory(full_path)  # Recursively delete subdirectory
    else
      File.delete(full_path)       # Delete file
    end
  end

  Dir.rmdir(path)  # Remove the now-empty directory
  puts "✅ Deleted: #{path}"
end

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
