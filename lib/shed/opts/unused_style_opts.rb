# encoding: utf-8

#
# Manages the command line interface for the unused style detection tool.
#
class UnusedStyleOpts < ToolOpts

  def self.name
    "as-style-detector"
  end

  def self.description
    "ActionScript Unused Style Detection Tool"
  end

  def self.default_config
    dc = superclass.default_config
    dc[:output] = 'styles.txt'
    dc[:css_dir] = 'style'
    dc
  end

  def self.add_mandatory(op,config)
    superclass.add_mandatory(op,config)

    op.on("-c", "--css PATH", "Path to the directory containing css file/s.") do |v|
      config[:css_dir] = v
    end
  end

end
