# encoding: utf-8

#
# Takes an ActionScript 3 Interface file and generates a concrete implementation
# from it.
#
class Concrete < Tool
  def initialize(opt,out=STDOUT)
    super(opt,out)

    @interface = opt[:interface]

    do_exit unless valid_opts

    create_mixer(opt[:type])
    generate(File.new(@interface).read)
  end

  #
  # Valid if an Interface has been supplied in the options.
  #
  def valid_opts
    File.exist?(@interface) rescue false
  end

  #
  # Parse the Interface and outputs the concrete document.
  #
  def generate(file)
    @parser = Interface.new(file) rescue do_exit
    output
  end

  private

  #
  # Output the constructed document.
  #
  def output
    puts head + accessors + methods + foot
  end

  #
  # Create the mixing tool which determines the output format.
  #
  def create_mixer(type)
    mixers = { 'imp' => JustImplement,
               'class' => ActionScriptClass,
               'mock4as' => Mock4AS }

    @mixer = mixers[type].new
    @mixer
  end

  #
  # Generate the file header.
  #
  def head
    @mixer.head(@parser.class_name,@parser.name)
  end

  #
  # Generate the accessor block.
  #
  def accessors
    decs = ""
    @parser.properties.each_pair { |name,property|
      type = property[:type]

      decs << @mixer.get(name,type) if property[:gets]
      decs << @mixer.set(name,type) if property[:sets]
    }
    decs
  end

  #
  # Generate the method block.
  #
  def methods
    decs = ""
    @parser.methods.each_pair { |name,method|
      decs << @mixer.method(name, method[:arguments], method[:return])
    }
    decs
  end

  #
  # Generate the file footer.
  #
  def foot
    @mixer.foot
  end

  #
  # Log an error message and raise exit.
  #
  def do_exit
    super "The specified interface file does not exist, or is not an Interface."
  end
end
