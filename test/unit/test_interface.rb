# encoding: utf-8

require File.join(File.dirname(__FILE__), "/../test_helper")

class TestInterface < Test::Unit::TestCase

  def fix
    File.expand_path(File.dirname(__FILE__)+ "/../fixtures/interface")
  end

  context "load an interface with multiline methods and tokenise the contents" do
    #TODO
    setup do
      file = File.new("#{fix}/ISeedPacket.as").read.strip
      @parser = Interface.new(file)
    end

   should "identify the interface name" do
      assert_equal('ISeedPacket', @parser.name)
    end

    should "identify the interface package" do
      assert_equal('org.shed.bench.box', @parser.package)
    end

    should "identify the accessors" do
      p = @parser.get_property('material')

      assert_not_nil(p)
      assert(p[:gets])
      assert(p[:sets])
      assert_equal('String', p[:type])
      assert_equal(1, @parser.properties.length)
    end

    should "identify multiline methods defined in the interface" do
      m = @parser.get_method('variety')

      assert_not_nil(m)
      assert_equal('variety', m[:name])
      assert_equal(['one:Number', 'two:String', 'three:Function'], m[:arguments])
      assert_equal('String', m[:return])
    end

    should "identify multiline methods with default arguments" do
      m = @parser.get_method('age')

      assert_not_nil(m)
      assert_equal('age', m[:name])
      assert_equal(['planted:Date', 'details:String="a,b,c"'], m[:arguments])
      assert_equal('Date', m[:return])
    end
  end

  context "load an interface and tokenise the contents" do
    setup do
      file = File.new("#{fix}/IShed.as").read.strip
      @parser = Interface.new(file)
    end

    should "identify the interface name" do
      assert_equal('IShed', @parser.name)
    end

    should "identify the interface package" do
      assert_equal('', @parser.package)
    end

    should "identify the accessors" do
      p = @parser.get_property('windows')

      assert_not_nil(p)
      assert(p[:gets])
      assert(p[:sets])
      assert_equal('int', p[:type])
      assert_equal(3, @parser.properties.length)
    end

    should "identify the setters" do
      p = @parser.get_property('lamps')

      assert_not_nil(p)
      assert(!p[:gets])
      assert(p[:sets])
      assert_equal('Number', p[:type])
    end

    should "identify getters" do
      p = @parser.get_property('doors')

      assert_not_nil(p)
      assert(p[:gets])
      assert(!p[:sets])
      assert_equal('uint', p[:type])
    end

    should "identify all methods defined in the interface" do
      m = @parser.get_method('openDoor')

      assert_not_nil(m)
      assert_equal('openDoor', m[:name])
      assert_equal([], m[:arguments])
      assert_equal('void', m[:return])

      m = @parser.get_method('startHeater')

      assert_not_nil(m)
      assert_equal('startHeater', m[:name])
      assert_equal(['temperature:Number','fuel:String'], m[:arguments])
      assert_equal('void', m[:return])

      m = @parser.get_method('countTools')

      assert_not_nil(m)
      assert_equal('countTools', m[:name])
      assert_equal([], m[:arguments])
      assert_equal('Number', m[:return])

      assert_equal(3, @parser.methods.length)
    end

  end

end