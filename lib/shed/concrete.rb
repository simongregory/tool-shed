# encoding: utf-8

#
# Takes an ActionScript 3 Interface file and generates a Concrete class from it.
#
class Concrete < Tool
  def initialize(opt,out=STDOUT)
    super(opt,out)

    @interface = opt[:interface]

    do_exit unless valid_opts

    create_mixer(opt[:type])
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

  def create_mixer(type)
    @mixer = ActionScriptClass.new
    @mixer = Mock4AS.new if type == 'mock4as'
    @mixer
  end

  def head
    c_name = @parser.name.sub(/^I/,'')
    i_face = @parser.name
    @mixer.head(c_name,i_face)
  end

  def accessors
    decs = ""
    @parser.properties.each_pair { |key,prop|
      name, type = prop[:name], prop[:type]
      sets, gets = prop[:sets], prop[:gets]

      decs << @mixer.get(name,type) if gets
      decs << @mixer.set(name,type) if sets
    }
    decs
  end

  def methods
    decs = ""
    @parser.methods.each_pair { |key, val|
      args = val[:arguments]
      decs << @mixer.method('',key,args,val[:return])
    }
    decs
  end

  def foot
    @mixer.foot
  end

  def do_exit
    @out.puts "#{INVALID_OPTS} The specified interface file does not exist, or is not an Interface."
    exit
  end
end
