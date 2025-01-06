def run_command(cmd)
  output, status = Open3.capture2e(cmd)
  abort "Command failed! Command: #{cmd}, Output: #{output}" unless status.exitstatus.zero?
  output.chomp
end

Dir.glob(File.join('tasks/**/*.rake')).each { |file| load file }
