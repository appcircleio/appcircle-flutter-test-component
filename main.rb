require 'open3'
require 'pathname'

def get_env_variable(key)
	return (ENV[key] == nil || ENV[key] == "") ? nil : ENV[key]
end

ac_repo_path = get_env_variable("AC_REPOSITORY_DIR") || abort('Missing repo path.')
ac_flutter_project_path = get_env_variable("AC_FLUTTER_PROJECT_PATH") || "."
ac_flutter_test_extra_args = get_env_variable("AC_FLUTTER_TEST_EXTRA_ARGS") || "--machine"

def run_command(command)
    puts "@[command] #{command}"
    status = nil
    stdout_str = nil
    stderr_str = nil

    Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
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
    return stdout_str
end

absolute_flutter_project_path = ""
if Pathname.new("#{ac_flutter_project_path}").absolute?
    absolute_flutter_project_path = ac_flutter_project_path
else
    absolute_flutter_project_path = File.expand_path(File.join(ac_repo_path, ac_flutter_project_path))
end

run_command("cd #{absolute_flutter_project_path} && flutter test #{ac_flutter_test_extra_args}")

exit 0