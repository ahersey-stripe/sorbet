# typed: __STDLIB_INTERNAL

# [`Shell`](https://docs.ruby-lang.org/en/2.6.0/Shell.html) implements an
# idiomatic Ruby interface for common UNIX shell commands.
#
# It provides users the ability to execute commands with filters and pipes, like
# `sh`/`csh` by using native facilities of Ruby.
#
# ## Examples
#
# ### Temp file creation
#
# In this example we will create three `tmpFile`'s in three different folders
# under the `/tmp` directory.
#
# ```ruby
# sh = Shell.cd("/tmp") # Change to the /tmp directory
# sh.mkdir "shell-test-1" unless sh.exists?("shell-test-1")
# # make the 'shell-test-1' directory if it doesn't already exist
# sh.cd("shell-test-1") # Change to the /tmp/shell-test-1 directory
# for dir in ["dir1", "dir3", "dir5"]
#   if !sh.exists?(dir)
#     sh.mkdir dir # make dir if it doesn't already exist
#     sh.cd(dir) do
#       # change to the `dir` directory
#       f = sh.open("tmpFile", "w") # open a new file in write mode
#       f.print "TEST\n"            # write to the file
#       f.close                     # close the file handler
#     end
#     print sh.pwd                  # output the process working directory
#   end
# end
# ```
#
# ### Temp file creation with self
#
# This example is identical to the first, except we're using
# CommandProcessor#transact.
#
# CommandProcessor#transact executes the given block against self, in this case
# `sh`; our [`Shell`](https://docs.ruby-lang.org/en/2.6.0/Shell.html) object.
# Within the block we can substitute `sh.cd` to `cd`, because the scope within
# the block uses `sh` already.
#
# ```ruby
# sh = Shell.cd("/tmp")
# sh.transact do
#   mkdir "shell-test-1" unless exists?("shell-test-1")
#   cd("shell-test-1")
#   for dir in ["dir1", "dir3", "dir5"]
#     if !exists?(dir)
#       mkdir dir
#       cd(dir) do
#         f = open("tmpFile", "w")
#         f.print "TEST\n"
#         f.close
#       end
#       print pwd
#     end
#   end
# end
# ```
#
# ### Pipe /etc/printcap into a file
#
# In this example we will read the operating system file `/etc/printcap`,
# generated by `cupsd`, and then output it to a new file relative to the `pwd`
# of `sh`.
#
# ```ruby
# sh = Shell.new
# sh.cat("/etc/printcap") | sh.tee("tee1") > "tee2"
# (sh.cat < "/etc/printcap") | sh.tee("tee11") > "tee12"
# sh.cat("/etc/printcap") | sh.tee("tee1") >> "tee2"
# (sh.cat < "/etc/printcap") | sh.tee("tee11") >> "tee12"
# ```
class Shell
  include(::Shell::Error)

  # Creates a [`Shell`](https://docs.ruby-lang.org/en/2.6.0/Shell.html) object
  # which current directory is set to the process current directory, unless
  # otherwise specified by the `pwd` argument.
  def self.new(pwd = _, umask = _); end

  # Alias for:
  # [`chdir`](https://docs.ruby-lang.org/en/2.6.0/Shell.html#method-i-chdir)
  def cd(path = _, verbose = _); end

  # Creates a [`Shell`](https://docs.ruby-lang.org/en/2.6.0/Shell.html) object
  # which current directory is set to `path`.
  #
  # If a block is given, it restores the current directory when the block ends.
  #
  # If called as iterator, it restores the current directory when the block
  # ends.
  #
  # Also aliased as:
  # [`cd`](https://docs.ruby-lang.org/en/2.6.0/Shell.html#method-i-cd)
  def chdir(path = _, verbose = _); end

  def debug; end

  def debug=(val); end

  def expand_path(path); end

  def inspect; end

  # Sends the given `signal` to the given `job`
  def kill(sig, command); end

  # Alias for:
  # [`popdir`](https://docs.ruby-lang.org/en/2.6.0/Shell.html#method-i-popdir)
  def popd; end

  # Pops a directory from the directory stack, and sets the current directory to
  # it.
  #
  # Also aliased as:
  # [`popd`](https://docs.ruby-lang.org/en/2.6.0/Shell.html#method-i-popd)
  def popdir; end

  # Alias for:
  # [`pushdir`](https://docs.ruby-lang.org/en/2.6.0/Shell.html#method-i-pushdir)
  def pushd(path = _, verbose = _); end

  # Pushes the current directory to the directory stack, changing the current
  # directory to `path`.
  #
  # If `path` is omitted, it exchanges its current directory and the top of its
  # directory stack.
  #
  # If a block is given, it restores the current directory when the block ends.
  #
  # Also aliased as:
  # [`pushd`](https://docs.ruby-lang.org/en/2.6.0/Shell.html#method-i-pushd)
  def pushdir(path = _, verbose = _); end

  # Returns the command search path in an array
  def system_path; end

  # Sets the system path (the
  # [`Shell`](https://docs.ruby-lang.org/en/2.6.0/Shell.html) instance's PATH
  # environment variable).
  #
  # `path` should be an array of directory name strings.
  def system_path=(path); end

  # Convenience method for
  # [`Shell::CommandProcessor.alias_command`](https://docs.ruby-lang.org/en/2.6.0/Shell/CommandProcessor.html#method-c-alias_command).
  # Defines an instance method which will execute a command under an alternative
  # name.
  #
  # ```ruby
  # Shell.def_system_command('date')
  # Shell.alias_command('date_in_utc', 'date', '-u')
  # Shell.new.date_in_utc # => Sat Jan 25 16:59:57 UTC 2014
  # ```
  def self.alias_command(ali, command, *opts, &block); end

  # Creates a new [`Shell`](https://docs.ruby-lang.org/en/2.6.0/Shell.html)
  # instance with the current working directory set to `path`.
  def self.cd(path); end

  def self.debug; end

  def self.debug=(val); end

  # Convenience method for
  # [`Shell::CommandProcessor.def_system_command`](https://docs.ruby-lang.org/en/2.6.0/Shell/CommandProcessor.html#method-c-def_system_command).
  # Defines an instance method which will execute the given shell command. If
  # the executable is not in
  # [`Shell.default_system_path`](https://docs.ruby-lang.org/en/2.6.0/Shell.html#method-c-default_system_path),
  # you must supply the path to it.
  #
  # ```ruby
  # Shell.def_system_command('hostname')
  # Shell.new.hostname # => localhost
  #
  # # How to use an executable that's not in the default path
  #
  # Shell.def_system_command('run_my_program', "~/hello")
  # Shell.new.run_my_program # prints "Hello from a C program!"
  # ```
  def self.def_system_command(command, path = _); end

  def self.default_record_separator; end

  def self.default_record_separator=(rs); end

  # Returns the directories in the current shell's PATH environment variable as
  # an array of directory names. This sets the
  # [`system_path`](https://docs.ruby-lang.org/en/2.6.0/Shell.html#attribute-i-system_path)
  # for all instances of
  # [`Shell`](https://docs.ruby-lang.org/en/2.6.0/Shell.html).
  #
  # Example: If in your current shell, you did:
  #
  # ```
  # $ echo $PATH
  # /usr/bin:/bin:/usr/local/bin
  # ```
  #
  # Running this method in the above shell would then return:
  #
  # ```ruby
  # ["/usr/bin", "/bin", "/usr/local/bin"]
  # ```
  def self.default_system_path; end

  # Sets the
  # [`system_path`](https://docs.ruby-lang.org/en/2.6.0/Shell.html#attribute-i-system_path)
  # that new instances of
  # [`Shell`](https://docs.ruby-lang.org/en/2.6.0/Shell.html) should have as
  # their initial system\_path.
  #
  # `path` should be an array of directory name strings.
  def self.default_system_path=(path); end

  # Convenience method for Shell::CommandProcessor.install\_system\_commands.
  # Defines instance methods representing all the executable files found in
  # [`Shell.default_system_path`](https://docs.ruby-lang.org/en/2.6.0/Shell.html#method-c-default_system_path),
  # with the given prefix prepended to their names.
  #
  # ```ruby
  # Shell.install_system_commands
  # Shell.new.sys_echo("hello") # => hello
  # ```
  def self.install_system_commands(pre = _); end

  def self.notify(*opts); end

  # Convenience method for
  # [`Shell::CommandProcessor.unalias_command`](https://docs.ruby-lang.org/en/2.6.0/Shell/CommandProcessor.html#method-c-unalias_command)
  def self.unalias_command(ali); end

  # Convenience method for
  # [`Shell::CommandProcessor.undef_system_command`](https://docs.ruby-lang.org/en/2.6.0/Shell/CommandProcessor.html#method-c-undef_system_command)
  def self.undef_system_command(command); end
end

class Shell::AppendFile < ::Shell::AppendIO
  Elem = type_member(:out)

  def self.new(sh, to_filename, filter); end

  def input=(filter); end
end

class Shell::AppendIO < ::Shell::BuiltInCommand
  Elem = type_member(:out)

  def self.new(sh, io, filter); end

  def input=(filter); end
end

class Shell::BuiltInCommand < ::Shell::Filter
  Elem = type_member(:out)

  def active?; end

  def wait?; end
end

class Shell::Cat < ::Shell::BuiltInCommand
  Elem = type_member(:out)

  def self.new(sh, *filenames); end

  def each(rs = _); end
end

# In order to execute a command on your OS, you need to define it as a
# [`Shell`](https://docs.ruby-lang.org/en/2.6.0/Shell.html) method.
#
# Alternatively, you can execute any command via
# [`Shell::CommandProcessor#system`](https://docs.ruby-lang.org/en/2.6.0/Shell/CommandProcessor.html#method-i-system)
# even if it is not defined.
class Shell::CommandProcessor
  def self.new(shell); end

  # See
  # [`Shell::CommandProcessor#test`](https://docs.ruby-lang.org/en/2.6.0/Shell/CommandProcessor.html#method-i-test)
  #
  # Alias for:
  # [`test`](https://docs.ruby-lang.org/en/2.6.0/Shell/CommandProcessor.html#method-i-test)
  def [](command, file1, file2 = _); end

  def append(to, filter); end

  # Returns a Cat object, for the given `filenames`
  def cat(*filenames); end

  # Returns a Concat object, for the given `jobs`
  def concat(*jobs); end

  # [`CommandProcessor#expand_path(path)`](https://docs.ruby-lang.org/en/2.6.0/Shell/CommandProcessor.html#method-i-expand_path)
  #
  # ```
  #   path:   String
  #   return: String
  # returns the absolute path for <path>
  # ```
  def expand_path(path); end

  # private functions
  def find_system_command(command); end

  # See
  # [`IO.foreach`](https://docs.ruby-lang.org/en/2.6.0/IO.html#method-c-foreach)
  # when `path` is a file.
  #
  # See
  # [`Dir.foreach`](https://docs.ruby-lang.org/en/2.6.0/Dir.html#method-c-foreach)
  # when `path` is a directory.
  def foreach(path = _, *rs); end

  # ```ruby
  # def sort(*filenames)
  #   Sort.new(self, *filenames)
  # end
  # ```
  #
  # Returns a Glob filter object, with the given `pattern` object
  def glob(pattern); end

  # Same as
  # [`Dir.mkdir`](https://docs.ruby-lang.org/en/2.6.0/Dir.html#method-c-mkdir),
  # except multiple directories are allowed.
  def mkdir(*path); end

  # %pwd, %cwd -> @pwd
  def notify(*opts); end

  # See [`IO.open`](https://docs.ruby-lang.org/en/2.6.0/IO.html#method-c-open)
  # when `path` is a file.
  #
  # See [`Dir.open`](https://docs.ruby-lang.org/en/2.6.0/Dir.html#method-c-open)
  # when `path` is a directory.
  def open(path, mode = _, perm = _, &b); end

  # Calls `device.print` on the result passing the *block* to
  # [`transact`](https://docs.ruby-lang.org/en/2.6.0/Shell/CommandProcessor.html#method-i-transact)
  def out(dev = _, &block); end

  # Clears the command hash table.
  def rehash; end

  # Same as
  # [`Dir.rmdir`](https://docs.ruby-lang.org/en/2.6.0/Dir.html#method-c-rmdir),
  # except multiple directories are allowed.
  def rmdir(*path); end

  # Executes the given `command` with the `options` parameter.
  #
  # Example:
  #
  # ```ruby
  # print sh.system("ls", "-l")
  # sh.system("ls", "-l") | sh.head > STDOUT
  # ```
  def system(command, *opts); end

  # Returns a Tee filter object, with the given `file` command
  def tee(file); end

  # Tests if the given `command` exists in `file1`, or optionally `file2`.
  #
  # Example:
  #
  # ```ruby
  # sh[?e, "foo"]
  # sh[:e, "foo"]
  # sh["e", "foo"]
  # sh[:exists?, "foo"]
  # sh["exists?", "foo"]
  # ```
  #
  #
  # Also aliased as:
  # [`top_level_test`](https://docs.ruby-lang.org/en/2.6.0/Shell/CommandProcessor.html#method-i-top_level_test),
  # [`[]`](https://docs.ruby-lang.org/en/2.6.0/Shell/CommandProcessor.html#method-i-5B-5D)
  def test(command, file1, file2 = _); end

  # Executes a block as self
  #
  # Example:
  #
  # ```ruby
  # sh.transact { system("ls", "-l") | head > STDOUT }
  # ```
  def transact(&block); end

  # See IO.unlink when `path` is a file.
  #
  # See
  # [`Dir.unlink`](https://docs.ruby-lang.org/en/2.6.0/Dir.html#method-c-unlink)
  # when `path` is a directory.
  def unlink(path); end

  # Creates a command alias at the given `alias` for the given `command`,
  # passing any `options` along with it.
  #
  # ```ruby
  # Shell::CommandProcessor.alias_command "lsC", "ls", "-CBF", "--show-control-chars"
  # Shell::CommandProcessor.alias_command("lsC", "ls"){|*opts| ["-CBF", "--show-control-chars", *opts]}
  # ```
  def self.alias_command(ali, command, *opts); end

  # Returns a list of aliased commands
  def self.alias_map; end

  # Defines a command, registering `path` as a
  # [`Shell`](https://docs.ruby-lang.org/en/2.6.0/Shell.html) method for the
  # given `command`.
  #
  # ```ruby
  # Shell::CommandProcessor.def_system_command "ls"
  #   #=> Defines ls.
  #
  # Shell::CommandProcessor.def_system_command "sys_sort", "sort"
  #   #=> Defines sys_sort as sort
  # ```
  def self.def_system_command(command, path = _); end

  def self.method_added(id); end

  # include run file.
  def self.run_config; end

  # Unaliases the given `alias` command.
  def self.unalias_command(ali); end

  # Undefines a command
  def self.undef_system_command(command); end
end

class Shell::Concat < ::Shell::BuiltInCommand
  Elem = type_member(:out)

  def self.new(sh, *jobs); end

  def each(rs = _); end
end

class Shell::Echo < ::Shell::BuiltInCommand
  Elem = type_member(:out)

  def self.new(sh, *strings); end

  def each(rs = _); end
end

module Shell::Error
end

# Any result of command execution is a
# [`Filter`](https://docs.ruby-lang.org/en/2.6.0/Shell/Filter.html).
#
# This class includes
# [`Enumerable`](https://docs.ruby-lang.org/en/2.6.0/Enumerable.html), therefore
# a [`Filter`](https://docs.ruby-lang.org/en/2.6.0/Shell/Filter.html) object can
# use all [`Enumerable`](https://docs.ruby-lang.org/en/2.6.0/Enumerable.html)
# facilities.
class Shell::Filter
  include(::Enumerable)

  Elem = type_member(:out)

  def self.new(sh); end

  # Outputs `filter1`, and then `filter2` using Join.new
  def +(filter); end

  # Inputs from `source`, which is either a string of a file name or an
  # [`IO`](https://docs.ruby-lang.org/en/2.6.0/IO.html) object.
  def <(src); end

  # Outputs from `source`, which is either a string of a file name or an
  # [`IO`](https://docs.ruby-lang.org/en/2.6.0/IO.html) object.
  def >(to); end

  # Appends the output to `source`, which is either a string of a file name or
  # an [`IO`](https://docs.ruby-lang.org/en/2.6.0/IO.html) object.
  def >>(to); end

  # Iterates a block for each line.
  def each(rs = _); end

  def input=(filter); end

  def inspect; end

  def to_a; end

  def to_s; end

  # Processes a pipeline.
  def |(filter); end
end

class Shell::Glob < ::Shell::BuiltInCommand
  Elem = type_member(:out)

  def self.new(sh, pattern); end

  def each(rs = _); end
end

class Shell::ProcessController
  def self.new(shell); end

  def active_job?(job); end

  def active_jobs; end

  def active_jobs_exist?; end

  # schedule a command
  def add_schedule(command); end

  def jobs; end

  def jobs_exist?; end

  # kill a job
  def kill_job(sig, command); end

  # simple fork
  def sfork(command); end

  # start a job
  def start_job(command = _); end

  # terminate a job
  def terminate_job(command); end

  # wait for all jobs to terminate
  def wait_all_jobs_execution; end

  def waiting_job?(job); end

  def waiting_jobs; end

  def waiting_jobs_exist?; end

  def self.activate(pc); end

  def self.active_process_controllers; end

  def self.block_output_synchronize(&b); end

  def self.each_active_object; end

  def self.inactivate(pc); end

  def self.wait_to_finish_all_process_controllers; end
end

class Shell::SystemCommand < ::Shell::Filter
  Elem = type_member(:out)

  def self.new(sh, command, *opts); end

  def active?; end

  def command; end

  # Also aliased as:
  # [`super_each`](https://docs.ruby-lang.org/en/2.6.0/Shell/SystemCommand.html#method-i-super_each)
  def each(rs = _); end

  def flush; end

  def input=(inp); end

  def kill(sig); end

  def name; end

  # ex)
  #
  # ```
  # if you wish to output:
  #    "shell: job(#{@command}:#{@pid}) close pipe-out."
  # then
  #    mes: "job(%id) close pipe-out."
  # yorn: Boolean(@shell.debug? or @shell.verbose?)
  # ```
  def notify(*opts); end

  def start; end

  def start_export; end

  def start_import; end

  # Alias for:
  # [`each`](https://docs.ruby-lang.org/en/2.6.0/Shell/SystemCommand.html#method-i-each)
  def super_each(rs = _); end

  def terminate; end

  def wait?; end
end

class Shell::Tee < ::Shell::BuiltInCommand
  Elem = type_member(:out)

  def self.new(sh, filename); end

  def each(rs = _); end
end

class Shell::Void < ::Shell::BuiltInCommand
  Elem = type_member(:out)

  def self.new(sh, *opts); end

  def each(rs = _); end
end