# encoding: utf-8

#
# Takes an ActionScript 3 Interface file and generates a Mock4AS class from it.
#
class Mock4AS < ActionScriptClass
  def head(name,interface)
    "package\n{\n\nclass #{name}Mock extends Mock implements #{interface}\n{\n\nimport org.mock4as.Mock;\n\n"
  end

  protected

  def template(name,arguments,returns,type='')
    params = parameterize(arguments)
    record = (params == '') ? '' : ', ' + params.gsub(/:\w+\b/,"")

    str =  "    public function #{type}#{name}(#{params}):#{returns}\n"
    str << "    {\n"
    str << "        record('#{name}'#{record});\n"
    str << "        return expectedReturnFor('#{name}') as #{returns};\n" unless returns == 'void'
    str << "    }\n\n"
  end
end
