# encoding: utf-8

require File.join(File.dirname(__FILE__), "/../test_helper")

class MockOptTest < Test::Unit::TestCase

  context "A Mock Tool Options Parser" do

    should "return default hash if no arguments are specified" do
      args = []
      opts = MockOpts.parse(args)

      assert_equal false, opts[:verbose]
    end

    should "display a name" do
      assert_match(/\w+/, MockOpts.name)
    end

    should "describe itself" do
      assert_match(/\w+/, MockOpts.description)
    end

    should "define a type when -t is set" do
      arg = 'olate'
      opts = MockOpts.parse ['-t', arg]

      assert_equal arg, opts[:type]
    end

    should "define a type when --type is set" do
      arg = '4as'
      opts = MockOpts.parse ['--type', arg]

      assert_equal arg, opts[:type]
    end

    should "define a interface when -i is set" do
      arg = 'org.helvector.IShed'
      opts = MockOpts.parse ['-i', arg]

      assert_equal arg, opts[:interface]
    end

    should "define a interface when --interface is set" do
      arg = 'org.helvector.IShed'
      opts = MockOpts.parse ['--interface', arg]

      assert_equal arg, opts[:interface]
    end

  end

end
