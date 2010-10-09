# encoding: utf-8

#
# Manages the command line interface for the unused style detection tool.
#
class UnusedStyleOpts < ToolOpts

  def self.name
    "as-style-detector"
  end

  def self.description
    " ActionScript Unused Style Detection Tool"
  end

  def self.default_config
    dc = superclass.default_config
    dc[:output] = 'styles.txt'
    dc[:css_dir] = 'style'
    dc
  end

end
