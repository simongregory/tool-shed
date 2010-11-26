# encoding: utf-8

#
# Abstract base class for tool options which require the manifest and link
# report.
#
class VacuumOpts < ToolOpts

  def self.default_config
    dc = superclass.default_config
    dc[:manifest] = 'manifest.xml'
    dc[:link_report] = 'link-report.xml'
    dc
  end

  def self.add_mandatory(op,config)
    superclass.add_mandatory(op,config)

    op.on("-m", "--manifest FILE", "Path to the source manifest file.") do |v|
      config[:manifest] = v
    end

    op.on("-l", "--link-report FILE", "Path to the compiler link-report file.") do |v|
      config[:link_report] = v
    end
  end
end