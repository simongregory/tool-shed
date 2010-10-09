# encoding: utf-8

#
# Detects styles that are not used in a Flex application.
#
# This needs to be provided with a source directory to search for used styles,
# and a directory containing css files which will be loaded and parsed for
# style definitions.
#
# NOTE: This tool needs further work before it can be considerd to cover all
#       use cases.
#
class UnusedStyle < Tool
  attr_reader :report,
              :declared,
              :used,
              :unused,
              :undeclared

  def initialize(opt,out=STDOUT)
    super(opt,out)

    @css_dir = opt[:css_dir]

    @style_regex = /styleName\s*=\s*["']\s*\{?\s*([\w.]+)\s*\}?\s*["']/
    @declared_regex = /^\.(\w+)/

    @declared, @used, @unused, @undeclared = []

    unless valid_opts
      @out.puts "#{INVALID_OPTS} The directory specified as containging css files does not exist, or does not contain css files."
      return
    end

    detect

    @report = describe
  end

  def valid_opts
    return false unless File.exist?(@css_dir)

    found = Dir.chdir("#{@css_dir}") do |d|
      Dir.glob('*.css')
    end

    found.length > 0
  end

  def detect
    @declared = scan_dirs(/\.(css)/, @css_dir, @declared_regex)
    @used = scan_dirs(/\.(as|mxml)/, @src, @style_regex)

    #Find any style names used in the source which haven't been declared.
    @undeclared = @used-@declared

    #Find any style names declared in the css but not used in the src.
    @unused = @declared-@used
  end

  private

  #
  # Returns a string detailing the findings of the style detection.
  #
  def describe
    desc = "#{generated_at}"
    desc << add_desc("declared in CSS", @declared)
    desc << add_desc("used in MXML",@used)
    desc << add_desc("declared but not used (in a styleName property)",@unused)
    desc << add_desc("used but not declared",@undeclared)
    desc
  end

  #
  # Prints a description category.
  #
  def add_desc(txt,list)
    d = "\nStyles #{txt}: #{list.length.to_s}\n"
    d << list.join("\n") unless list.empty?
    d
  end

  #
  # Scans directories for all files that match the file extension regex, and
  # for each match goes on to scan that document for items matching the syntax
  # regex.
  #
  def scan_dirs(extension_regex,path,syntax_regex)
    d = []

    Search.find_all(extension_regex,path,@excludes) do |path|
      d << scan_doc(path,syntax_regex)
    end

    d.flatten!.sort!.uniq! unless d.empty?
    d
  end

  #
  # Opens the document specified by path and returns a list of all first capture
  # group matches, after stripping comments.
  #
  def scan_doc(path,regex)
    n = []
    f = File.open(path,"r").read.strip
    f = Stripper.comments(f)
    f.scan(regex) do |style_name|
      n << $1
    end
    n
  end

end
