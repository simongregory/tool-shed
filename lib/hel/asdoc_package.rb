# encoding: utf-8

#
# Reads '.asdoc' files from a specified source tree and concatencates them into
# a xml configuration file that can be used to generate ActionScript
# documentation for the Actionscript packages.
#
class ASDocPackage < Tool
  attr_reader :xml

  def initialize(opt,out=STDOUT)
    super(opt,out)

    @asdoc = /\.asdoc$/

    @header = "<?xml version='1.0' encoding='utf-8'?>\n<flex-config>\n\t<packages>"
    @package = "\t\t<package>\n\t\t\t<string>%s</string>\n\t\t\t<string><![CDATA[%s]]></string>\n\t\t</package>\n"
    @footer = "\t</packages>\n</flex-config>"

    build
  end

  #
  # Scan the given path and it's child directories for all .asdoc files.
  #
  def scan(path)
    puts "Scanning '#{path}' for asdoc files..."

    found = []

    Search.find_all(@asdoc,path,@excludes) do |p|
      found << {:path => p, :package => ProjectTools.package(p)}
    end

    found.each { |f| log("Adding #{f[:path]}") }

    found
  end

  #
  # Build the flex compiler config file that can be passed to the asdoc tool.
  #
  def build
    asdocs = scan(@src)

    if asdocs.empty?
      puts "No .asdoc files found."
    else
      @xml = create_xml(asdocs)
      to_disk(@xml)
    end
  end

  #
  # Constructs the flex complier config file when given a list of paths to asdoc
  # files.
  #
  def create_xml(asdocs)
    x = @header
    asdocs.each { |d| x << sprintf(@package, d[:package], IO.read(d[:path])) }
    x << @footer
    x
  end
end
