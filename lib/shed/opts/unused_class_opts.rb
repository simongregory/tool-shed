# encoding: utf-8

#
# Manages the command line interface for the unused classes detection tool.
#
class UnusedClassOpts < VacuumOpts

  def self.name
    "as-class-detector"
  end

  def self.description
    "ActionScript unused class detection tool"
  end

  def self.default_config
    dc = superclass.default_config
    dc[:output] = 'class-vaccum.txt'
    dc
  end

end
