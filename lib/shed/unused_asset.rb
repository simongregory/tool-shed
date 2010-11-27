# encoding: utf-8

#
# This script scans all Actionscript classes and CSS files in a project to
# identify assets, like PNG files, that are in the project source tree but are
# no longer used by the application.
#
class UnusedAsset < Tool
  attr_reader :assets, :declared, :unused

  def initialize(opt,out=STDOUT)
    super(opt,out)

    @project_dir = opt[:project_dir] || opt[:src] #remove src or refactor project_dir out
    @assets = []
    @src_files = []
    @declared = []

    unless valid_opts
      @out.puts "#{INVALID_OPTS} One or all of specified asset and source directories does not exist."
      return
    end

    detect

    @report = describe

    to_disk(@report)
  end

  #
  # Valid if the specified project directory exists.
  #
  def valid_opts
    File.exist?(@project_dir) rescue false
  end

  def detect
    Search.find_all(/\.(jpg|jpeg|png|otf|ttf|swf|svg|mp3|gif)$/,@project_dir,@excludes) do |path|
      @assets << path
    end

    src_dec = scan_dirs(/\.(as|mxml|css)$/, @project_dir, /Embed\(source=['"]([\w._\-\/]+)['"]/)
    css_dec = scan_dirs(/\.(css)$/, @project_dir, /:\s*url\(\s*['"](.*)['"]/)
    mxml_dec = scan_dirs(/\.(mxml)$/, @project_dir, /@Embed\(['"]([\w._\-\/]+)['"]/)

    @declared = src_dec + css_dec + mxml_dec
    @unused = []

    @assets.each { |ass| @unused << ass unless is_asset_used(ass) }
  end

  private

  #
  # Returns a string detailing the findings of the style detection.
  #
  def describe
    desc = "#{generated_at} by as-asset-detector"
    desc << add_desc("Assets declared in src", @declared)
    desc << add_desc("Assets found in project but not referenced in source", @unused)
    desc
  end

  def is_asset_used(file)
    used = false
    @declared.each { |declaration|
      if File.basename(declaration) == File.basename(file)
        used = true
      end
    }
    used
  end

end
