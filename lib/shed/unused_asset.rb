# encoding: utf-8

#
# This script scans all Actionscript classes and CSS files in a project to
# identify assets, like PNG files, that are in the project source tree but are
# no longer used by the application.
#
class UnusedAsset < Tool
  attr_reader :assets, :src_files, :declared, :unused

  def initialize(opt,out=STDOUT)
    super(opt,out)

    @project_dir = opt[:project_dir]
    @assets = []
    @src_files = []
    @declared = []

    unless valid_opts
      @out.puts "#{INVALID_OPTS} One or all of specified asset and source directories does not exist."
      return
    end

    @declared_regex = /Embed\(source='([\w.\/]+)'/

    detect

    #@report = describe

    #to_disk(@report)
  end

  def valid_opts
    File.exist?(@project_dir) rescue false
  end

  private

  def detect
    Search.find_all(/\.(jpg|jpeg|png|otf)$/,@project_dir,@excludes) do |path|
      @assets << path
    end

    @declared = scan_dirs(/\.(css|as|mxml)$/, @project_dir, @declared_regex)

    @unused = []

    @assets.each { |a|
      @unused << a unless is_used(a)
    }
  end

  def is_used(file)
    used = false
    @declared.each { |f|
      if File.basename(f) == File.basename(file)
        used = true
      end
    }
    used
  end

  #
  # Scans directories for all files that match the file extension regex, and
  # for each match goes on to scan that document for items matching the syntax
  # regex.
  #
  def scan_dirs(file_ext_regex,path,syntax_regex)
    d = []

    Search.find_all(file_ext_regex,path,@excludes) do |p|
      @src_files << p
      d << scan_doc(p,syntax_regex)
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