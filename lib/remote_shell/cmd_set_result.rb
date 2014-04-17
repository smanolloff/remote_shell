class RemoteShell::CmdSetResult
  attr_reader :cmd_set

  def initialize(cmd_set)
    @cmd_set = cmd_set
    @results = []
  end

  def add(cmd, output, exit_code)
    @results << OpenStruct.new(cmd: cmd, output: output, ecode: exit_code)
  end

  def report
    report_ary = []
    @results.each.with_index(1) do |result, i|
      report_ary << " ---- (#{i}) Command (sanitized during execution):"
      report_ary << result.cmd.illustrate
      report_ary << " ---- (#{i}) Exit status: #{result.ecode}"
      report_ary << " ---- (#{i}) Outputs (STDOUT and STDERR):"
      report_ary << result.output
    end
    report_ary.join("\n")
  end

  def output
    @results.map(&:output).join
  end

  def success?
    @results.map(&:ecode).all?(&:zero?)
  end
end
