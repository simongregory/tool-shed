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

    @src = opt[:src]
    @assets, @src_files, @declared = [], [], []

    unless valid_opts
      @out.puts "#{INVALID_OPTS} The source directory does not exist."
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
    File.exist?(@src) rescue false
  end

  def detect
    puts "Scanning project for assets that are unused..."

    Search.find_all(/\.(jpg|jpeg|png|otf|ttf|swf|svg|mp3|gif)$/,@src,@excludes) do |path|
      @assets << path
    end

    src_dec = scan_dirs(/\.(as|mxml|css)$/, @src, /Embed\(source=['"]([\w._\-\/]+)['"]/)
    css_dec = scan_dirs(/\.(css)$/, @src, /:\s*url\(\s*['"](.*)['"]/)
    mxml_dec = scan_dirs(/\.(mxml)$/, @src, /@Embed\(['"]([\w._\-\/]+)['"]/)

    @declared = src_dec + css_dec + mxml_dec
    @unused = []

    @assets.each { |ass| @unused << ass unless is_asset_used(ass) }

    summarise
  end

  private

  #
  # Summarise the collected data.
  #
  def summarise
    puts "Used assets: #{@declared.length.to_s}"
    puts "Unused assets: #{@unused.length.to_s}"
  end

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
