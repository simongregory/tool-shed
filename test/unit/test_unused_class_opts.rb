# encoding: utf-8

require File.join(File.dirname(__FILE__), "/../test_helper")

class UnusedClassOptsTest < Test::Unit::TestCase

  context "A Unused Class Tool Options Parser" do

    should "return default hash if no arguments are specified" do

      args = []
      opts = UnusedClassOpts.parse(args)

      assert_equal 'classes.txt', opts[:output]
      assert_equal 'manifest.xml', opts[:manifest]
      assert_equal 'link-report.xml', opts[:link_report]
      assert_equal '.', opts[:src]
      assert_equal false, opts[:verbose]

    end

    should "display a name" do
      assert_match(/\w+/, UnusedClassOpts.name)
    end

    should "describe itself" do
      assert_match(/\w+/, UnusedClassOpts.description)
    end

  end

end
