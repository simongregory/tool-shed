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
    @excludes = opt[:excludes] || ['.svn','.git', 'bin', 'bin-debug']
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
    file = File.open(@output, "w")
    file.puts str
    file.flush
    file.close

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

  protected

  #
  # Describes a list of collected data.
  #
  def add_desc(heading,list)
    description = "\n\n#{heading}: #{list.length.to_s}\n\n\t"
    description << list.join("\n\t") unless list.empty?
    description
  end

  #
  # Opens the document specified by path and returns a list of all first capture
  # group matches, after stripping comments.
  #
  def scan_doc(path,regex)
    caputres = []
    file = File.open(path,"r").read.strip
    file = Stripper.comments(file)
    file.scan(regex) { caputres << $1 }
    caputres
  end

  #
  # Scans directories for all files that match the regex, and for each match
  # goes on to scan that document for items matching the syntax regex.
  #
  def scan_dirs(extension,dir,syntax_regex)
    declarations = []

    Search.find_all(extension,dir,@excludes) do |path|
      declarations << scan_doc(path,syntax_regex)
    end

    declarations.flatten!.sort!.uniq! unless declarations.empty?
    declarations
  end

  #
  # Log an error message and raise exit.
  #
  def do_exit(msg='')
    @out.puts "#{INVALID_OPTS} #{msg}"
    exit
  end
end
