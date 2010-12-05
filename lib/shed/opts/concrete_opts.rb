# encoding: utf-8

#
# Manages the command line interface for the ActionScript 3 Mock Framework Class
# generation tool.
#
class ConcreteOpts < ToolOpts

  def self.name
    "as-concrete"
  end

  def self.description
    "ActionScript Concrete Class Generator"
  end

  def self.default_config
    dc = superclass.default_config
    dc[:type] = 'class'
    dc
  end

  def self.add_optional(op,config)
    op.on("-i", "--interface FILE", String, "File path to ActionScript interface file.") do |value|
      config[:interface] = value
    end

    op.on("-t", "--type STRING", String, "Optional output type, defaults to 'class'. Accepts 'class', 'mock4as' and 'imp'.") do |value|
      config[:type] = value
    end
  end

end
