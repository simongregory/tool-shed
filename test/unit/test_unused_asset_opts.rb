# encoding: utf-8

require File.join(File.dirname(__FILE__), "/../test_helper")

class UnusedAssetOptsTest < Test::Unit::TestCase

  context "A Unused Asset Tool Options Parser" do

    should "return default hash if no arguments are specified" do

      args = []
      opts = UnusedAssetOpts.parse(args)

      assert_equal 'assets.txt', opts[:output]
      assert_equal 'manifest.xml', opts[:manifest]
      assert_equal 'link-report.xml', opts[:link_report]
      assert_equal '.', opts[:src]
      assert_equal false, opts[:verbose]

    end

    should "display a name" do
      assert_match(/\w+/, UnusedAssetOpts.name)
    end

    should "describe itself" do
      assert_match(/\w+/, UnusedAssetOpts.description)
    end

  end

end
