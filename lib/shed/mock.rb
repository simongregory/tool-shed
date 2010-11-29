# encoding: utf-8

#
# Takes an ActionScript 3 Interface file and generates a Mock class from it.
#
class Mock < Tool
  def initialize(opt,out=STDOUT)
    super(opt,out)

    @interface = opt[:interface]

    do_exit unless valid_opts

    generate(File.new(@interface).read)
  end

  def valid_opts
    File.exist?(@interface) rescue false
  end

  def generate(file)
    @parser = Interface.new(file) rescue do_exit

    puts head + accessors + methods + foot
  end

  private

  def head
    i_face = @parser.name
    c_name = @parser.name.sub(/^I/,'')
    "package\n{\n\nclass #{c_name}Mock extends Mock implements #{i_face}\n{\n\n"
  end

  def accessors
    decs = ""
    @parser.properties.each_pair { |key,prop|
      decs << make_method('get ',prop[:name], '', 'void', '') if prop[:sets]
      decs << make_method('set ',prop[:name], "value:#{prop[:type]}", prop[:type], '') if prop[:gets]
    }
    decs
  end

  def methods
    decs = ""
    @parser.methods.each_pair { |key, val|
      args = val[:arguments].to_s
      rec = (args == '') ? '' : ', ' + args.gsub(/:\w+\b/,"")

      decs << make_method('',key,args,val[:return],rec)
    }
    decs
  end

  def make_method(type,name,args,ret,rec)
    template =  "    public function #{type}#{name}(#{args}):#{ret}\n"
    template << "    {\n"
    template << "        record('#{name}'#{rec});\n"
    template << "        return expectedReturnFor('#{name}') as #{ret};\n" unless ret == 'void'
    template << "    }\n\n"
  end

  def foot
    "\n}\n}\n"
  end

  def do_exit
    @out.puts "#{INVALID_OPTS} The specified interface file does not exist, or is not an Interface."
    exit
  end
end
