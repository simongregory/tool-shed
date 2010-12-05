# encoding: utf-8

#
# Takes an ActionScript 3 Interface file and generates a ActionScript class from
# it.
#
class ActionScriptClass
  def head(name,interface)
    "package\n{\n\nclass #{name} implements #{interface}\n{\n\n"
  end

  def get(name,type)
    method(name, '', type,'get ')
  end

  def set(name,type)
    method(name, "value:#{type}", 'void','set ')
  end

  def parameterize(arguments)
    arguments = arguments.join(', ') if arguments.is_a? Array
    arguments
  end

  def method(name,arguments,returns,type='')
    template =  "    public function #{type}#{name}(#{parameterize(arguments)}):#{returns}\n"
    template << "    {\n"
    template << "        return;\n" unless returns == 'void'
    template << "    }\n\n"
  end

  def foot
    "\n}\n}\n"
  end
end