# encoding: utf-8

require File.join(File.dirname(__FILE__), "/../test_helper")

class MockTest < Test::Unit::TestCase

  def fix
    File.expand_path(File.dirname(__FILE__)+ "/../fixtures/interface")
  end

  context "A mock generator tool running with a missing interface file" do

    should "exit with an error message" do

      opts = MockOpts.parse ['-i', "#{fix}/IDoNotExist.as"]
      out = StringIO.new

      begin
        Mock.new(opts,out)
        flunk
      rescue SystemExit => e
        assert_equal 0, e.status
        assert_match(/#{Mock::INVALID_OPTS}/, out.string)
      end

    end
  end

  context "A mock generator tool given an invalid interface file" do

    should "exit with an error message" do

      opts = MockOpts.parse ['-i', "#{fix}/Shed.as"]
      out = StringIO.new

      begin
        Mock.new(opts,out)
        flunk
      rescue SystemExit => e
        assert_equal 0, e.status
        assert_match(/#{Mock::INVALID_OPTS}/, out.string)
      end

    end
  end

  context "A mock generator tool" do

    context "outputting actionscript classes" do

      setup do
        opts = MockOpts.parse ['-i', "#{fix}/IShed.as"]
        @out = StringIO.new
        @mock = Mock.new(opts,@out)
      end

      should "output a string" do
        assert_not_nil(@out.string)
      end

      should "output a package declaration" do
        assert_match(/^package/, @out.string)
      end

      should "output a class declaration" do
        assert_match(/^class Shed/, @out.string)
      end

      should "implement the expected interface" do
        assert_match(/implements IShed$/, @out.string)
      end

      should "output getters with the expected return type" do
        assert_match(/public function get windows\(\):int/, @out.string)
        assert_match(/public function get doors\(\):uint/, @out.string)
      end

      should "output setters with the correct return type" do
        assert_match(/public function set windows\(value:int\):void/, @out.string)
      end

      should "output setters with correct argument type" do
        assert_match(/set windows\(value:int\)/, @out.string)
        assert_match(/public function set windows\(value:int\)/, @out.string)
      end

      should "output methods" do
        assert_match(/public function startHeater\(/, @out.string)
        assert_match(/public function countTools\(\):Number/, @out.string)
      end

      should "output methods with the expected arguments" do
        assert_match(/public function startHeater\(temperature:Number, fuel:String\):void/, @out.string)
      end

      should "output methods which return the expected values" do
        assert_match(/return;/, @out.string)
      end

      should "have valid options" do
        assert @mock.valid_opts
      end
    end

    context "outputting mock 4 as classes" do

      setup do
        opts = MockOpts.parse ['-i', "#{fix}/IShed.as", '-t', 'mock4as']
        @out = StringIO.new
        @mock = Mock.new(opts,@out)
      end

      should "output a string" do
        assert_not_nil(@out.string)
      end

      should "output a package declaration" do
        assert_match(/^package/, @out.string)
      end

      should "output a class declaration" do
        assert_match(/^class ShedMock/, @out.string)
      end

      should "extend a Mock" do
        assert_match(/extends Mock/, @out.string)
      end

      should "implement the expected interface" do
        assert_match(/implements IShed$/, @out.string)
      end

      should "output getters with the expected return type" do
        assert_match(/public function get windows\(\):int/, @out.string)
        assert_match(/public function get doors\(\):uint/, @out.string)
      end

      should "output getters with record statements" do
        assert_match(/record\('windows'\);/, @out.string)
      end

      should "output setters with the correct return type" do
        assert_match(/public function set windows\(value:int\):void/, @out.string)
      end

      should "output setters with correct argument type" do
        assert_match(/set windows\(value:int\)/, @out.string)
        assert_match(/public function set windows\(value:int\)/, @out.string)
      end

      should "output methods" do
        assert_match(/public function startHeater\(/, @out.string)
        assert_match(/public function countTools\(\):Number/, @out.string)
      end

      should "output methods with the expected arguments" do
        assert_match(/public function startHeater\(temperature:Number, fuel:String\):void/, @out.string)
      end

      should "output methods with record statements" do
        assert_match(/record\('openDoor'\);/, @out.string)
        assert_match(/record\('countTools'\);/, @out.string)
        assert_match(/record\('startHeater', temperature, fuel\);/, @out.string)
      end

      should "output methods which return the expected values" do
        assert_match(/return expectedReturnFor\('countTools'\) as Number;/, @out.string)
      end

      should "have valid options" do
        assert @mock.valid_opts
      end
    end

  end

end
