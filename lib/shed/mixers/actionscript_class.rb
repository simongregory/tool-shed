# encoding: utf-8

#
# Takes an ActionScript 3 Interface file and generates a ActionScript class from
# it.
#
class ActionScriptClass

  #
  # Returns a string formatted as the head of a ActionScript document.
  #
  def head(name,interface)
    "package\n{\n\nclass #{name} implements #{interface}\n{\n\n"
  end

  #
  # Returns a string formatted as a public ActionScript getter.
  #
  def get(name,type)
    template(name, '', type,'get ')
  end

  #
  # Returns a string formatted as a public ActionScript setter.
  #
  def set(name,type)
    template(name, "value:#{type}", 'void','set ')
  end

  #
  # Returns a string formatted as a public ActionScript method.
  #
  def method(name,arguments,returns)
    template(name,arguments,returns)
  end

  #
  # Returns a string formatted as the footer of a ActionScript document.
  #
  def foot
    "\n}\n}\n"
  end

  protected

  #
  # Utility to convert the specified arguments to valid ActionScript method
  # parameters.
  #
  def parameterize(arguments)
    arguments = arguments.join(', ') if arguments.is_a? Array
    arguments
  end

  #
  # Returns a string formatted as a public ActionScript method. If a type is
  # specified the method will be an implicit getter or setter.
  #
  def template(name,arguments,returns,type='')
    str =  "    public function #{type}#{name}(#{parameterize(arguments)}):#{returns}\n"
    str << "    {\n"
    str << "        return;\n" unless returns == 'void'
    str << "    }\n\n"
  end
end