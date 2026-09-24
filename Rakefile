require 'open3'

RED = "\033[31m".freeze
GREEN = "\033[32m".freeze
RESET = "\033[0m".freeze

def run_command(cmd, silent: true, print_command: false, report_status: false)
  puts "#{GREEN}Running #{cmd}#{RESET}" if print_command
  output = ''
  Open3.popen2e(cmd) do |_stdin, stdout_stderr, thread|
    stdout_stderr.each do |line|
      puts line unless silent
      output += line
    end
    exitcode = thread.value.exitstatus
    unless exitcode.zero?
      err = "#{RED}Command failed! Command: #{cmd}, Exit code: #{exitcode}"
      # Print details if we were running silent
      err += "\nOutput:\n#{output}" if silent
      err += RESET
      abort err
    end
    puts "#{GREEN}Command finished with status #{exitcode}#{RESET}" if report_status
  end
  output.chomp
end

begin
  require 'rubocop/rake_task'
rescue LoadError
  # Do nothing if no required gem installed
else
  RuboCop::RakeTask.new(:rubocop) do |task|
    # These make the rubocop experience maybe slightly less terrible
    task.options = ['--display-cop-names', '--display-style-guide', '--extra-details']
    # Use Rubocop's Github Actions formatter if possible
    task.formatters << 'github' if ENV['GITHUB_ACTIONS'] == 'true'
  end
end

Dir.glob(File.join('tasks/**/*.rake')).each { |file| load file }
