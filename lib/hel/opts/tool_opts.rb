# encoding: utf-8

require 'optparse'

#
# Abstract layer for the helvector tools options parsers. This sets the basic
# paramaters the tools respond to via the command line.
#
class ToolOpts

  #
  # The name of the tool, as invoked on the command line.
  #
  def self.name
    HelTool::NAME
  end

  #
  # A basic description of the tools use.
  #
  def self.description
    'Helvector Tool'
  end

  #
  # A version string to describe the version of the tool these options are
  # designed to invoke.
  #
  def self.version
    HelTool::VERSION::STRING
  end

  #
  # Default configuration hash.
  #
  def self.default_config
    {
      :src => ".",
      :output => 'output.xml',
      :verbose => false,
      :silent => false
    }
  end

  #
  # Create and return the options parser with the default header.
  #
  def self.create_parser
    op = OptionParser.new
    op.banner = "Usage: #{name} [options]"

    op.separator ""
    op.separator "Options:"
    op
  end

  #
  # Add all mandatory arguments to the options parser.
  #
  def self.add_mandatory(op,config)
  end

  #
  # Add all optional arguments to the options parser.
  #
  def self.add_optional(op,config)
    op.on("-s", "--source [PATH]", String, "Path to source folder, defaults to current directory.") do |v|
      config[:src] = v
    end

    op.on("-o", "--output [FILE PATH]", String, "Path to output file, defaults to #{config[:output]}") do |v|
      config[:output] = v
    end

    op.on("-v", "--verbose", "Run verbosely") do |v|
      config[:verbose] = v
    end

    op.on("--silent", "Supress all output.") do |v|
      config[:silent] = v
    end
  end

  def self.add_tail(op,out)
    op.on_tail("-h", "--help", "Show this help message") do
      out.puts op
      exit
    end

    op.on_tail("--version", "Show version") do
      out.puts "#{description} version #{version}"
      exit
    end
  end

  #
  # Parse the arugments and return a config hash.
  #
  def self.parse(args,out=STDOUT)

    config = default_config()
    options = create_parser()

    add_mandatory(options,config)
    add_optional(options,config)

    add_tail(options,out)

    options.parse!(args)

    config
  end

end
