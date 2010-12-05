# encoding: utf-8

#
# ActionScript 3 Interface Parser. Tokenises the contents of an interface into
# hashes.
#
# All methods and properties are stored in Hashes. Details of methods can be
# obtained via :name String, :arguments Array, return: String. Properies have
# the keys :name String, :gets Boolean, :sets Boolean, and :type String.
#
class Interface
  attr_reader :name,
              :class_name,
              :properties,
              :methods,
              :package

  def initialize(string)
    @doc = Stripper.ecma_comments(string)

    @properties, @methods = {}, {}
    @package, @name = '', ''

    raise "Document is not an interface" unless is_valid
    parse
  end

  #
  # Returns the method hash associated with request name.
  #
  def get_method(name)
    @methods[name]
  end

  #
  # Returns the proptert hash associated with request name.
  #
  def get_property(name)
    @properties[name]
  end

  private

  #
  # Detect if the supplied string is a valid ActionScript Interface file.
  #
  def is_valid
    @doc.scan(/^\s*public\s+(interface)\s+(\w+)\b/)
    return true if $1 == "interface"
    return false
  end

  #
  # Parses the supplied string for all relevant information.
  #
  def parse
    find_name
    find_package
    find_methods
    find_getters
    find_setters
  end

  #
  # Finds the name of the interface.
  #
  def find_name
    regexp = /^(\s+)?public\s+interface\s+(\w+)\b/
    @doc.scan(regexp).each { |line|
      @name = line[1]
      @class_name = @name.sub(/^I/,'')
    }
  end

  #
  # Finds the package of the interface.
  #
  def find_package
    regexp = /^(\s+)?package\s+([A-Za-z0-9.]+)/
    @doc.scan(regexp).each { |line| @package = line[1] }
  end

  #
  # Finds all methods defined in the interface.
  #
  def find_methods
    regexp = /^\s*function\s+\b([a-z]\w+)\b\s*\((([^)\n]*)|(?m:[^)]+))\)\s*:\s*((\w+|\*))/

    @doc.scan(regexp).each do |line|
      add_method(line[0],line[1],line[3])
    end
  end

  #
  # Finds all getters defined in the interface.
  #
  def find_getters
    regexp = accessor_regexp('get')

    @doc.scan(regexp).each do |line|
      prop = create_prop(line[1])
      prop[:type] = line[5]
      prop[:gets] = true;
    end
  end

  #
  # Finds all setters defined in the interface.
  #
  def find_setters
    regexp = accessor_regexp('set')

    @doc.scan(regexp).each do |line|
      prop = create_prop(line[1])
      prop[:type] = line[2].split(':')[1]
      prop[:sets] = true;
    end
  end

  #
  # Adds a method hash to the list of methods.
  #
  def add_method(name,arguments,returns)
    @methods[name] = {
      :name => name,
      :arguments => parameterize(arguments),
      :return => returns
    }
  end

  #
  # Converts method arguments into an arry of parameters.
  #
  def parameterize(params)
    arr = []
    params.gsub!(/(\s|\n)/,'')
    params.scan(/(\b\w+\b\s*:\s*\b\w+\b(=\s*(['"].*['"]|\w+))?|(\.\.\.\w+))/).each do |match|
      arr << match[0]
    end
    arr
  end

  #
  # Constructs the regular expression used when finding accessors.
  #
  def accessor_regexp(type='get|set')
    /^\s*function\s+\b(#{type})\b\s+\b(\w+)\b\s*\(([^)\n]*)(\)(\s*:\s*(\w+|\*))?)?/
  end

  #
  # Creates a default property hash.
  #
  def create_prop(name)
    unless @properties.has_key? name
      @properties[name] = {
        :gets => false,
        :sets => false,
        :name => name
      }
    end
    @properties[name]
  end
end
