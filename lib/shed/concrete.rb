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
    output
  end

  private

  def output
    puts head + accessors + methods + foot
  end

  def create_mixer(type)
    mixers = { 'imp' => JustImplement,
               'class' => ActionScriptClass,
               'mock4as' => Mock4AS }

    @mixer = mixers[type].new
    @mixer
  end

  def head
    c_name = @parser.name.sub(/^I/,'')
    i_face = @parser.name
    @mixer.head(c_name,i_face)
  end

  def accessors
    decs = ""
    @parser.properties.each_pair { |name,property|
      type = property[:type]

      decs << @mixer.get(name,type) if property[:gets]
      decs << @mixer.set(name,type) if property[:sets]
    }
    decs
  end

  def methods
    decs = ""
    @parser.methods.each_pair { |name,method|
      decs << @mixer.method(name, method[:arguments], method[:return])
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
