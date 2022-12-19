# frozen_string_literal: true

require 'open3'
require 'pathname'
require 'fileutils'

def get_env_variable(key)
  ENV[key].nil? || ENV[key] == '' ? nil : ENV[key]
end

ac_flutter_project_dir = get_env_variable('AC_FLUTTER_PROJECT_DIR') || abort('Missing Flutter project directory.')
ac_flutter_test_extra_args = get_env_variable('AC_FLUTTER_TEST_EXTRA_ARGS') || '--machine'
ac_flutter_junit = get_env_variable('AC_FLUTTER_JUNIT_REPORTS')

def run_command(command)
  puts "@@[command] #{command}"
  status = nil
  stdout_str = nil
  stderr_str = nil

  Open3.popen3(command) do |_stdin, stdout, stderr, wait_thr|
    stdout.each_line do |line|
      puts line
    end
    stdout_str = stdout.read
    stderr_str = stderr.read
    status = wait_thr.value
  end

  unless status.success?
    puts stderr_str
    raise stderr_str
  end
  stdout_str
end

if ac_flutter_junit == 'YES'
  reports_folder = File.join(ENV['AC_OUTPUT_DIR'], 'flutter_reports')
  File.open(ENV['AC_ENV_FILE_PATH'], 'a') do |f|
    f.puts "AC_TEST_RESULT_PATH=#{reports_folder}"
  end
  FileUtils.mkdir_p reports_folder
  run_command('flutter pub global activate junitreport')
  ac_flutter_test_extra_args += " | #{ENV['HOME']}/.pub-cache/bin/tojunit --output #{reports_folder}/flutter_result.xml"
end
run_command("cd #{ac_flutter_project_dir} && flutter test #{ac_flutter_test_extra_args}")

exit 0
