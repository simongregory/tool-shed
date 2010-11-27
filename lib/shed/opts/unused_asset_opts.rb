# encoding: utf-8

#
# Manages the command line interface for the unused assets detection tool.
#
class UnusedAssetOpts < ToolOpts

  def self.name
    "as-asset-detector"
  end

  def self.description
    "ActionScript Unused Asset Detection Tool"
  end

  def self.default_config
    dc = superclass.default_config
    dc[:output] = 'assets.txt'
    dc
  end

end
