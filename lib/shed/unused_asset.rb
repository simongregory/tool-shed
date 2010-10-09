# encoding: utf-8

#
# This script scans all Actionscript classes and CSS files in a project to
# identify assets, like PNG files, that are in the project source tree but are
# no longer used by the application.
#
class UnusedAsset < Tool
  def initialize(opt,out=STDOUT)
    super(opt,out)

    @link_report = opt[:link_report]
    @manifest = opt[:manifest]

    unless valid_opts
      @out.puts "#{INVALID_OPTS} One or all of specified link report, manifest file, and source directories does not exist."
      return
    end

    @declared_regex = /^TODO/

    detect

    @report = describe

    to_disk(@report)
  end

  def valid_opts
    File.exist?(@link_report) && File.exist?(@manifest) && File.exist?(@src) rescue false
  end

  def detect
    @declared = scan_dirs(/\.(css|as|mxml)/, @src, @declared_regex)
  end

  private

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