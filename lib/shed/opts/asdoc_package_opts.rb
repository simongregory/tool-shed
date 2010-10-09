# encoding: utf-8

#
# Manages the command line interface for the ASDoc Package File tool.
#
class ASDocPackageOpts < ToolOpts

  def self.name
    'as-docp'
  end

  def self.description
    'ASDoc Package Builder'
  end

  def self.default_config
    dc = superclass.default_config
    dc[:output] = 'package-asdoc.xml'
    dc
  end

end
