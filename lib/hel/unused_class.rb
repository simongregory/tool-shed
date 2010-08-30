# encoding: utf-8

#
# This tool compares a mxmlc generated link-report against a manifest file
# created by the as-manifest tool to identify files that are in the project
# source tree but are no longer used by the application.
#
# Before executing this script make sure the relevant link reports and manifest
# files have been generated.
#
class UnusedClass < Tool
  attr_reader :report,
              :empty_packages,
              :unused_classes

  def initialize(opt,out=STDOUT)
    super(opt,out)

    @link_report = opt[:link_report]
    @manifest = opt[:manifest]
    @link_regex = /<script name=".*\/(\w+)\.(as|mxml)/
    @manifest_regex = /<component id="(\w+)"/

    unless valid_opts
      @out.puts "#{INVALID_OPTS} One or all of specified link report, manifest file, and source directories does not exist."
      return
    end

    detect

    @report = describe

    to_disk(@report)
  end

  def valid_opts
    File.exist?(@link_report) && File.exist?(@manifest) && File.exist?(@src) rescue false
  end

  def detect
    puts "Scanning project for classes that are uncompiled..."

    @manifest_classes = linked(@manifest, @manifest_regex, 'manifest')
    @link_classes = linked(@link_report, @link_regex, 'link-report')

    @unused_classes = @manifest_classes-@link_classes
    @empty_packages = scan(@src)

    puts "Unused classes: #{@unused_classes.length.to_s}"
    puts "Empty packages: #{@empty_packages.length.to_s}"
  end

  private

  #
  # Scans the path for empty directories and lists them.
  #
  def scan(path)
    e = []
    Search.for_empties(path) { |p| e << p.sub( /^.*src\//, "") }
    e
  end

  #
  # Returns a string detailing the findings of the unused class detection.
  #
  def describe
    d = generated_at
    d << add_desc(" classes are in the manifest but not in the link report:", @unused_classes)
    d << add_desc(" packages appear to be empty:", @empty_packages)
    d
  end

  #
  # Prints a description category.
  #
  def add_desc(txt,list)
    l = list.empty? ? '' : list.join("\n")
    "#{list.length} #{txt}\n#{l}"
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

end
