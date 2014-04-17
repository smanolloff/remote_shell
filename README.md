# RemoteShell

Execute shell commands via SSH.
Very simple and easy to use, but not (yet) very flexible.

## Installation

Add this line to your application's Gemfile:

    gem 'remote_shell'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install remote_shell

## Usage

    require 'remote_shell'

    # The SSH host, user and pass (nil if using pubkey)
    ssh = { user: 'simo', pass: '123456', fqdn: 'localhost' }
    cmd_set = RemoteShell::CmdSet.new(ssh[:fqdn], ssh[:user], ssh[:pass])

    # Some commands to execute
    cmd_set.add_command(ShellCmd.new('date', '+%s'))
    cmd_set.add_command(ShellCmd.new('whoami'))
    result = cmd_set.execute_all

    # Inspect the results
    result.success?
    # => true

    result.output
    # => "1397728415\nsimo\n"

    puts result.report
    #  ---- (1) Command (sanitized during execution):
    # date '+%s'
    #  ---- (1) Exit status: 0
    #  ---- (1) Outputs (STDOUT and STDERR):
    # 1397728415
    #
    #  ---- (2) Command (sanitized during execution):
    # whoami
    #  ---- (2) Exit status: 0
    #  ---- (2) Outputs (STDOUT and STDERR):
    # simo
    # => nil

## Contributing

1. Fork it ( http://github.com/smanolloff/remote_shell/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
