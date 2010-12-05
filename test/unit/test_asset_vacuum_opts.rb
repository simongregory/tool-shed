# encoding: utf-8

require File.join(File.dirname(__FILE__), "/../test_helper")

class TestAssetVacuumOpts < Test::Unit::TestCase

  context "An Asset Vacuum Tool Options Parser" do

    should "return default hash if no arguments are specified" do
      args = []
      opts = AssetVacuumOpts.parse(args)

      assert_equal 'assets.txt', opts[:output]
      assert_equal '.', opts[:src]
      assert_equal false, opts[:verbose]
    end

    should "display a name" do
      assert_match(/\w+/, AssetVacuumOpts.name)
    end

    should "describe itself" do
      assert_match(/\w+/, AssetVacuumOpts.description)
    end

  end
end
