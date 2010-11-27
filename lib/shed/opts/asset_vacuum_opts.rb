# encoding: utf-8

#
# Manages the command line interface for the assets vacuum tool.
#
class AssetVacuumOpts < ToolOpts

  def self.name
    "as-asset-vacuum"
  end

  def self.description
    "ActionScript Asset Vacuum Tool"
  end

  def self.default_config
    dc = superclass.default_config
    dc[:output] = 'assets.txt'
    dc
  end

end
