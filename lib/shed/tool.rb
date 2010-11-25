# encoding: utf-8

#
# Abstract base class for tools. Provides basic default settings, allows
# control over the level of logging to standard out, and installs a sig int
# handler.
#
class Tool

  INVALID_OPTS = "Invalid options:"

  def initialize(opt,out=STDOUT)
    @src      = opt[:src] || '.'
    @output   = opt[:output] || 'tool-shed.txt'
    @verbose  = opt[:verbose] || false
    @silent   = opt[:silent] || false
    @excludes = opt[:excludes] || ['.svn','.git']
    @out      = out

    add_sigint_handler
  end

  #
  # Puts the message unless we are in silent mode.
  #
  def puts(msg)
    @out.puts msg unless @silent
  end

  #
  # Puts the message if we are in verbose mode (but not in silent mode).
  #
  def log(msg)
    puts msg if @verbose
  end

  #
  # Validates the opts the tool has been invoked with.
  #
  def valid_opts
    true
  end

  #
  # Write the requested string to the output file.
  #
  def to_disk(str)
    f = File.open(@output, "w")
    f.puts str
    f.flush
    f.close

    puts "Saved result to #{File.expand_path(@output)}."
  end

  #
  # Generate a timestamp to include in reports.
  #
  def generated_at
    "Generated at " + Time.now.strftime("[%m/%d/%Y %H:%M:%S]")
  end

  #
  # Installs a sigint handler.
  #
  def add_sigint_handler
    trap 'INT' do
      puts '\nCancelled. Bye Bye!'
      exit!
    end
  end

end
