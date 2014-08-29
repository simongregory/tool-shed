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

    @filetypes = /\.(as|mxml|fxg)$/
    @filter = opt[:filter] || ''

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
  def scan(dir)
    puts "Scanning '#{dir}' for as and mxml files..."

    found = []

    Search.find_all(@filetypes,dir,@excludes) do |path|
      ext = File.extname(path)
      name = File.basename(path, ext)

      found << add(path, name)
    end

    found = process(found) unless found.empty?

    found
  end

  #
  # Proccesses the list to remove duplicates, sort alphabetically and reject any
  # items that do not match the filter.
  #
  def process(list)
    list.uniq!
    list.sort! { |before,after| before[:xml] <=> after[:xml] }
    list.select { |element| element[:xml].match(@filter) }
  end

  #
  # Build the manifest file and save it to disk.
  #
  def build
    @components = scan(@src)

    if @components.empty?
      puts "No ActionScript, MXML or FXG files found."
    else
      create_xml(@components)

      #Open/Create the manifest file and write the output to it.
      to_disk(xml)
    end
  end

  #
  # Constructs the flex complier config file when given a list of paths to asdoc
  # files.
  #
  def create_xml(comps)
    @xml = "<?xml version='1.0'?>\n<componentPackage>\n"
    comps.each { |component| @xml << "\t#{component[:xml]}\n" }
    @xml << "</componentPackage>"
  end
end
