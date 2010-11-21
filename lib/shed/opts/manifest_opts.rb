# encoding: utf-8

#
# Manages the command line interface for the AS3 Manifest File generation tool.
#
class ManifestOpts < ToolOpts

  def self.description
    "ActionScript Manifest Generator Tool"
  end

  def self.name
    "as-manifest"
  end

  def self.default_config
    dc = superclass.default_config
    dc[:output] = "manifest.xml"
    dc
  end

  def self.add_optional(op,config)
    superclass.add_optional(op,config)
    op.on("-f", "--filter [STRING]", String, "Package filter, in the form of 'org.helvector', to include in the generated manifest.") do |v|
      config[:filter] = v
    end
  end

end
