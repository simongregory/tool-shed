# encoding: utf-8

#
# Manages the command line interface for the ActionScript 3 Mock Framework Class
# generation tool.
#
class MockOpts < ToolOpts

  def self.name
    "as-mock"
  end

  def self.description
    "ActionScript Mock Class Generator"
  end

  def self.add_optional(op,config)
    op.on("-i", "--interface FILE", String, "File path to ActionScript interface file.") do |value|
      config[:interface] = value
    end

    op.on("-t", "--type STRING", String, "Output type, use 'class' or 'mock4as'") do |value|
      config[:type] = value
    end
  end

end
