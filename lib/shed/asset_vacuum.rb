# encoding: utf-8

#
# This script scans all Actionscript classes and CSS files in a project to
# identify assets, like PNG files, that are in the project source tree but are
# no longer used by the application.
#
class AssetVacuum < Tool
  attr_reader :assets,
              :declared,
              :unused

  def initialize(opt,out=STDOUT)
    super(opt,out)

    @src = opt[:src]
    @assets, @src_files, @declared, @unused = [], [], [], []

    do_exit unless valid_opts

    detect

    @report = describe

    to_disk(@report)
  end

  #
  # Validates the given opts. Returns a boolean indicating if the src directory
  # specified can be used.
  #
  def valid_opts
    File.exist?(@src) rescue false
  end

  #
  # Scans the project and detects usage statitics for the assets it's finds.
  #
  def detect
    puts "Scanning project for assets that are unused..."

    scan_for_assets
    scan_for_declared

    @assets.each { |ass| @unused << ass unless is_asset_used(ass) }

    summarise
  end

  private

  #
  # Finds all assets in the source directory.
  #
  def scan_for_assets
    Search.find_all(/\.(jpg|jpeg|png|otf|ttf|swf|svg|mp3|gif)$/,@src,@excludes) do |path|
      @assets << path
    end
  end

  #
  # Finds all asset declarations in the source files.
  #
  def scan_for_declared
    @declared = scan_dirs(/\.(as|mxml|css)$/, @src, /Embed\(source=['"]([\w._\-\/]+)['"]/)
    @declared += scan_dirs(/\.(css)$/, @src, /:\s*url\(\s*['"](.*)['"]/)
    @declared += scan_dirs(/\.(mxml)$/, @src, /@Embed\(['"]([\w._\-\/]+)['"]/)
  end

  #
  # Summarise the collected data and outputs a string detailing how many assets
  # are used/unused in the project.
  #
  def summarise
    puts sprintf("Used assets: %d\nUnused assets: %d", @declared.length, @unused.length)
  end

  #
  # Returns a string detailing the findings of the style detection.
  #
  def describe
    desc = "#{generated_at} by as-asset-vacuum"
    desc << add_desc("Assets declared in src", @declared)
    desc << add_desc("Assets found in project but not referenced in source", @unused)
    desc
  end

  #
  # Returns a boolean to indicate if the asset is referenced within the
  # application.
  #
  def is_asset_used(file)
    used = false
    @declared.each { |declaration|
      if File.basename(declaration) == File.basename(file)
        used = true
      end
    }
    used
  end

  #
  # Log an error message to disk and raise exit.
  #
  def do_exit
    super "The source directory does not exist."
  end
end
