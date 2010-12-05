# encoding: utf-8

#
# This tool compares a mxmlc generated link-report against a manifest file
# created by the as-manifest tool to identify files that are in the project
# source tree but are no longer used by the application.
#
# Before executing this script make sure the relevant link reports and manifest
# files have been generated.
#
class ClassVacuum < Tool
  attr_reader :report,
              :empty_packages,
              :unused_classes

  def initialize(opt,out=STDOUT)
    super(opt,out)

    @link_report = opt[:link_report]
    @manifest = opt[:manifest]
    @link_regex = /<script name=".*\/(\w+)\.(as|mxml)/
    @manifest_regex = /<component id="(\w+)"/
    @empty_packages = []

    do_exit unless valid_opts

    detect

    @report = describe

    to_disk(@report)
  end

  #
  # Valid if a link report, manifest and source directory has been supplied.
  #
  def valid_opts
    File.exist?(@link_report) && File.exist?(@manifest) && File.exist?(@src) rescue false
  end

  #
  # Scans the project and detects classes that are in the source tree that are
  # not in the compiler manifest report.
  #
  def detect
    puts "Scanning project for classes that are uncompiled..."

    @manifest_classes = linked(@manifest, @manifest_regex, 'manifest')
    @link_classes = linked(@link_report, @link_regex, 'link-report')

    @unused_classes = @manifest_classes-@link_classes
    find_empties(@src)

    summarise
  end

  private

  #
  # Summarise the collected data.
  #
  def summarise
    puts "Unused classes: #{@unused_classes.length.to_s}"
    puts "Empty packages: #{@empty_packages.length.to_s}"
  end

  #
  # Scans the path for empty directories and lists them.
  #
  def find_empties(path)
    Search.for_empties(path) { |path| @empty_packages << path.sub( /^.*src\//, "") }
  end

  #
  # Returns a string detailing the findings of the class vacuumer.
  #
  def describe
    desc = "#{generated_at} by as-class-vacuum"
    desc << add_desc("Classes in the manifest but not the link report", @unused_classes)
    desc << add_desc("Packages appear to be empty", @empty_packages)
    desc
  end

  #
  # Collects all the lines in the specified link file matching the regular
  # expression and returns them in a list.
  #
  def linked(link,rgx,desc)
    log("Loading #{desc}: #{File.expand_path(link)}")

    classes = []

    return classes unless !link.nil? && File.exists?(link)

    IO.readlines(link).each { |line|
      if line =~ rgx
          classes << $1.to_s
      end
    }

    classes
  end

  #
  # Log an error message to disk and raise exit.
  #
  def do_exit
    super "The link report, manifest file, or source directory does not exist."
  end
end
