# encoding: utf-8

#
# ActionScript 3 Interface Parser. Tokenises the contents of an interface into
# a ruby object.
#
class Interface
  attr_reader :name, :properties, :methods, :package

  def initialize(string)
    @doc = Stripper.ecma_comments(string)

    @properties, @methods = {}, {}
    @package, @name = '', ''

    raise "Document is not an interface" unless is_valid
    parse
  end

  def get_method(name)
    @methods[name]
  end

  def get_property(name)
    @properties[name]
  end

  private

  def is_valid
    @doc.scan(/^\s*public\s+(interface)\s+(\w+)\b/)
    return true if $1 == "interface"
    return false
  end

  def parse
    load_name
    load_package
    load_methods
    load_getters
    load_setters
  end

  def load_name
    regexp = /^(\s+)?public\s+interface\s+(\w+)\b/
    @doc.scan(regexp).each { |line| @name = line[1] }
  end

  def load_package
    regexp = /^(\s+)?package\s+([A-Za-z0-9.]+)/
    @doc.scan(regexp).each { |line| @package = line[1] }
  end

  def load_methods
    regexp = /^\s*function\s+\b([a-z]\w+)\b\s*\((([^)\n]*)|(?m:[^)]+))\)\s*:\s*((\w+|\*))/

    @doc.scan(regexp).each do |line|
      add_method(line[0],line[1],line[3])
    end
  end

  def add_method(name,params,returns)
    @methods[name] = { :name => name,
                       :arguments => process_params(params),
                       :return => returns }

  end

  def process_params(params)
    arr = []
    params.gsub!(/(\s|\n)/,'')
    params.scan(/(\b\w+\b\s*:\s*\b\w+\b(=\s*(['"].*['"]|\w+))?|(\.\.\.\w+))/).each do |match|
      arr << match[0]
    end
    arr
  end

  def accessor_regexp(type='get|set')
    /^\s*function\s+\b(#{type})\b\s+\b(\w+)\b\s*\(([^)\n]*)(\)(\s*:\s*(\w+|\*))?)?/
  end

  def load_getters
    regexp = accessor_regexp('get')

    @doc.scan(regexp).each do |line|
      prop = create_prop(line[1])
      prop[:type] = line[5]
      prop[:gets] = true;
    end
  end

  def load_setters
    regexp = accessor_regexp('set')

    @doc.scan(regexp).each do |line|
      prop = create_prop(line[1])
      prop[:type] = line[2].split(':')[1]
      prop[:sets] = true;
    end
  end

  def create_prop(name)
    if @properties[name].nil?
      @properties[name] = {
        :gets => false,
        :sets => false,
        :name => name
      }
    end
    @properties[name]
  end
end
