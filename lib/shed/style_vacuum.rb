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
class StyleVacuum < Tool
  attr_reader :report,
              :declared,
              :used,
              :unused,
              :undeclared

  def initialize(opt,out=STDOUT)
    super(opt,out)

    @css_dir = opt[:css_dir]

    do_exit unless valid_opts

    @style_regex = /styleName\s*=\s*["']\s*\{?\s*([\w.]+)\s*\}?\s*["']/
    @declared_regex = /^\.(\w+)/

    @declared, @used, @unused, @undeclared = [], [], [], []

    detect

    @report = describe

    to_disk(@report)
  end

  #
  # Valid if we can find .css files in the specifed css_dir.
  #
  def valid_opts
    return false unless File.exist?(@css_dir)

    found = Dir.chdir("#{@css_dir}") { Dir.glob('*.css') }

    found.length > 0
  end

  #
  # Scans the project and detects styles referenced in the source and css files.
  #
  def detect
    puts "Scanning project for styles..."

    @declared = scan_dirs(/\.(css)/, @css_dir, @declared_regex)
    @used = scan_dirs(/\.(as|mxml)/, @src, @style_regex)

    #Find any style names used in the source which haven't been declared.
    @undeclared = @used-@declared

    #Find any style names declared in the css but not used in the src.
    @unused = @declared-@used

    summarise
  end

  private

  #
  # Summarise the collected data.
  #
  def summarise
    puts sprintf( "Declared styles: %d\nUndeclared styles: %d\nUsed styles: %d\nUnused styles: %d\n",
      @declared.length, @undeclared.length, @used.length, @unused.length)
  end

  #
  # Returns a string detailing the findings of the style detection.
  #
  def describe
    desc = "#{generated_at} by as-style-vacuum"
    desc << add_desc("Styles declared in CSS", @declared)
    desc << add_desc("Styles used in MXML",@used)
    desc << add_desc("Styles declared but not used (in a styleName property)",@unused)
    desc << add_desc("Styles used but not declared",@undeclared)
    desc
  end

  #
  # Log an error message and raise exit.
  #
  def do_exit
    super "The specified css directory does not exist, or does not contain css files."
  end
end
