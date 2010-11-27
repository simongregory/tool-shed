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
    summary = "Declared styles: #{@declared.length.to_s}"
    summary << "Undeclared styles: #{@undeclared.length.to_s}"
    summary << "Used styles: #{@used.length.to_s}"
    summary << "Unused styles: #{@unused.length.to_s}"
    puts summary
  end

  #
  # Returns a string detailing the findings of the style detection.
  #
  def describe
    desc = "#{generated_at} by as-style-detector"
    desc << add_desc("Styles declared in CSS", @declared)
    desc << add_desc("Styles used in MXML",@used)
    desc << add_desc("Styles declared but not used (in a styleName property)",@unused)
    desc << add_desc("Styles used but not declared",@undeclared)
    desc
  end

end