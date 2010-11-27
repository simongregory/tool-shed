# encoding: utf-8

require File.join(File.dirname(__FILE__), "/../test_helper")

class ASDocPackageOptsTest < Test::Unit::TestCase

  context "A AsDoc Package Tool Options Parser" do

    should "return default hash if no arguments are specified" do
      args = []
      opts = ASDocPackageOpts.parse(args)

      assert_equal 'asdoc-package-config.xml', opts[:output]
      assert_equal '.', opts[:src]
      assert_equal false, opts[:verbose]
    end

    should "display a name" do
      assert_match(/\w+/, ASDocPackageOpts.name)
    end

    should "describe itself" do
      assert_match(/\w+/, ASDocPackageOpts.description)
    end

  end

end
