# encoding: utf-8

#
# Manages the command line interface for the style vacuum tool.
#
class StyleVacuumOpts < ToolOpts

  def self.name
    "as-style-vacuum"
  end

  def self.description
    "ActionScript Style Vacuum Tool"
  end

  def self.default_config
    dc = superclass.default_config
    dc[:output] = 'styles.txt'
    dc[:css_dir] = 'style'
    dc
  end

  def self.add_mandatory(op,config)
    superclass.add_mandatory(op,config)

    op.on("-c", "--css PATH", "Path to the directory containing css file/s.") do |value|
      config[:css_dir] = value
    end
  end

end
