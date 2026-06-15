require 'open3'

class KiroStep
  def initialize(dir:, prompt:, trust_tools: nil)
    @dir = dir
    @prompt = prompt
    @trust_tools = trust_tools
  end

  def run
    cmd = ["kiro-cli", "chat", "--no-interactive"]
    cmd += ["--trust-tools=#{@trust_tools}"] if @trust_tools
    cmd << @prompt

    stdout, stderr, status = Open3.capture3(*cmd, chdir: @dir)
    unless status.success?
      warn "[ERROR] kiro-cli failed in #{@dir}: #{stderr}"
      return nil
    end
    stdout.strip
  end
end
