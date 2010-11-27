# encoding: utf-8

#
# Manages the command line interface for the class vacuum tool.
#
class ClassVacuumOpts < ToolOpts

  def self.name
    "as-class-vacuum"
  end

  def self.description
    "ActionScript Class Vacuum Tool"
  end

  def self.default_config
    dc = superclass.default_config
    dc[:output] = 'class-vacuum.txt'
    dc[:manifest] = 'manifest.xml'
    dc[:link_report] = 'link-report.xml'
    dc
  end

  def self.add_mandatory(op,config)
    superclass.add_mandatory(op,config)

    op.on("-m", "--manifest FILE", "Path to the source manifest file.") do |value|
      config[:manifest] = value
    end

    op.on("-l", "--link-report FILE", "Path to the compiler link-report file.") do |value|
      config[:link_report] = value
    end
  end

end
