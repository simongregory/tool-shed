# encoding: utf-8

#
# Scans a specified source tree for ActionScript and MXML files and for each one
# found creates a manifest entry. When complete writes the resulting manfiest
# file to disk.
#
class Manifest < Tool
  attr_reader :components,
              :xml

  def initialize(opt,out=STDOUT)
    super(opt,out)

    @filetypes = /\.(as|mxml)$/

    build
  end

  #
  # Generates a hash containing id and xml vales. The xml can be to be inserted
  # into the manifest for the specified class.
  #
  def add(path, id)
    log("Adding '#{path}'")

    cp = ProjectTools.import(path)

    { :key => id, :xml => "<component id=\"#{id}\" class=\"#{cp}\" />" }
  end

  #
  # Search the provided path for as and mxml documents and return those found as
  # a list.
  #
  def scan(path)
    puts "Scanning '#{path}' for as and mxml files..."

    found = []

    Search.find_all(@filetypes,path,@excludes) do |p|
      ext = File.extname(p)
      cn = File.basename(p, ext)

      found << add(p, cn) if cn =~ /^[A-Z]/
    end

    found.uniq! unless found.empty?

    found
  end

  #
  # Build the manifest file and save it to disk.
  #
  def build
    @components = scan(@src)

    if @components.empty?
      puts "No ActionScript or Mxml files found."
    else

      @components.sort! {|a,b| a[:xml] <=> b[:xml] }

      @xml = create_xml(@components)

      #Open/Create the manifest file and write the output to it.
      to_disk(@xml)
    end
  end

  #
  # Constructs the flex complier config file when given a list of paths to asdoc
  # files.
  #
  def create_xml(comps)
    x = "<?xml version='1.0'?>\n<componentPackage>\n"
    comps.each { |c| x << "\t#{c[:xml]}\n" }
    x << "</componentPackage>"
    x
  end
end
