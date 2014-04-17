require 'spec_helper'

describe RemoteShell::CmdSetResult do
  let(:ssh) { { user: 'simo', pass: '123456', fqdn: 'localhost' } }
  let(:cmd_set) do
    RemoteShell::CmdSet.new(ssh[:fqdn], ssh[:user], ssh[:pass]).
      add_command(ShellCmd.new('echo', '-e', '\n this!'))
  end
  let(:result) { cmd_set.execute_all }

  subject { result }

  its(:cmd_set) { should be(cmd_set) }
  its(:output) { should eq("\n this!\n") }
  its(:success?) { should eq(true) }
  its(:report) do
    should eq(
      <<-END.gsub(/^\s+\|/, '')
      | ---- (1) Command (sanitized during execution):
      |echo '-e' '\\n this!'
      | ---- (1) Exit status: 0
      | ---- (1) Outputs (STDOUT and STDERR):
      |
      | this!
      END
    )
  end

  describe '#report' do
    it 'contains "(command not executed)" when commands fail' do
      cmd_set.add_command(ShellCmd.new('nonexistingcommand'))
      cmd_set.add_command(ShellCmd.new('iamnotexecuted'))
      cmd_set.execute_all rescue nil

      expect(cmd_set.result.report).to eq(
        <<-END.gsub(/^\s+\|/, '')
        | ---- (1) Command (sanitized during execution):
        |echo '-e' '\\n this!'
        | ---- (1) Exit status: 0
        | ---- (1) Outputs (STDOUT and STDERR):
        |
        | this!
        |
        | ---- (2) Command (sanitized during execution):
        |nonexistingcommand
        | ---- (2) Exit status: 127
        | ---- (2) Outputs (STDOUT and STDERR):
        |bash: nonexistingcommand: command not found
        |
        | ---- (3) Command (sanitized during execution):
        |iamnotexecuted
        | ---- (3) Exit status: N/A
        | ---- (3) Outputs (STDOUT and STDERR):
        END
      )
    end
  end
end
