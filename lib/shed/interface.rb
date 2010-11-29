# encoding: utf-8

#
# ActionScript 3 Interface Parser. Tokenises the contents of an interface into
# a ruby object.
#
class Interface
  attr_reader :name, :properties, :methods, :package

  def initialize(string)
    @raw = string
    @uncommented = Stripper.ecma_comments(string)

    @properties, @methods = {}, {}
    @package, @name = '', ''

    raise "Document is not an interface" unless is_valid(@uncommented)
    parse(@uncommented)
  end

  def get_method(name)
    @methods[name]
  end

  def get_property(name)
    @properties[name]
  end

  private

  def is_valid(doc)
    doc.scan(/^\s*public\s+(interface)\s+(\w+)\b/)
    return true if $1 == "interface"
    return false
  end

  def parse(doc)
    load_name(doc)
    load_package(doc)
    load_methods(doc)
    load_getters(doc)
    load_setters(doc)
  end

  def load_name(doc)
    regexp = /^(\s+)?public\s+interface\s+(\w+)\b/
    doc.scan(regexp).each { |line| @name = line[1] }
  end

  def load_package(doc)
    regexp = /^(\s+)?package\s+([A-Za-z0-9.]+)/
    doc.scan(regexp).each { |line| @package = line[1] }
  end

  def load_methods(doc)
    regexp = /^\s*function\s+\b([a-z]\w+)\b\s*\(([^)\n]*)(\)(\s*:\s*(\w+|\*))?)?/

    doc.scan(regexp).each do |line|
      name = line[0]
      @methods[name] = { :name => name,
                         :arguments => line[1],
                         :return => line[4] }
    end
  end

  def accessor_regexp(type='get|set')
    /^\s*function\s+\b(#{type})\b\s+\b(\w+)\b\s*\(([^)\n]*)(\)(\s*:\s*(\w+|\*))?)?/
  end

  def load_getters(doc)
    regexp = accessor_regexp('get')

    doc.scan(regexp).each do |line|
      prop = create_prop(line[1])
      prop[:type] = line[5]
      prop[:gets] = true;
    end
  end

  def load_setters(doc)
    regexp = accessor_regexp('set')

    doc.scan(regexp).each do |line|
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
