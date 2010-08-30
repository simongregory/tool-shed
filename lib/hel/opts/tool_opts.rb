# encoding: utf-8

require 'optparse'

#
# Abstract layer for the helvector tools options parsers. This sets the basic
# paramaters the tools respond to via the command line.
#
class ToolOpts

  def self.name
    HelTool::NAME
  end

  def self.description
    'Helvector Tool'
  end

  def self.version
    HelTool::VERSION::STRING
  end

  def self.default_config
    {
      :src => ".",
      :output => 'output.xml',
      :verbose => false,
      :silent => false
    }
  end

  #
  # http://ruby-doc.org/stdlib/libdoc/optparse/rdoc/classes/OptionParser.html
  #
  def self.parse(args,out=STDOUT)
    config = default_config

    options = OptionParser.new do |opts|
      opts.banner = "Usage: #{name} [options]"

      opts.separator ""
      opts.separator "Options:"

      opts.on("-s", "--source [PATH]", String,
              "Path to source folder, defaults to current directory.") do |v|
        config[:src] = v
      end

      opts.on("-o", "--output [PATH]", String,
              "Path to output XML file, defaults to #{config[:output]}") do |v|
        config[:output] = v
      end

      opts.on("-v", "--verbose", "Run verbosely") do |v|
        config[:verbose] = v
      end

      opts.on("--silent", "Supress all output.") do |v|
        config[:silent] = v
      end

      opts.on_tail("-h", "--help", "Show this message") do
        out.puts opts
        exit
      end

      opts.on_tail("--version", "Show version") do
        out.puts "#{description} version #{version}"
        exit
      end
    end

    options.parse!(args)

    config
  end

end
