# encoding: utf-8

require File.join(File.dirname(__FILE__), "/../test_helper")

class ManifestOptTest < Test::Unit::TestCase

  context "A Manifest Tool Options Parser" do

    should "return default hash if no arguments are specified" do
      args = []
      opts = ManifestOpts.parse(args)

      assert_equal 'manifest.xml', opts[:output]
      assert_equal '.', opts[:src]
      assert_equal false, opts[:verbose]
    end

    should "display a name" do
      assert_match(/\w+/, ManifestOpts.name)
    end

    should "describe itself" do
      assert_match(/\w+/, ManifestOpts.description)
    end

  end

end
