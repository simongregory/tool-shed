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

  context "A mock generator tool given a invalid interface file" do

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
    setup do
      opts = MockOpts.parse ['-i', "#{fix}/IShed.as"]
      @out = StringIO.new
      @mock = Mock.new(opts,@out)
    end

    #should "generate a mock class" do
    #  puts @out.string
    #end

    should "have valid options" do
      assert @mock.valid_opts
    end
  end

end
