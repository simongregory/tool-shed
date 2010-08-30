# encoding: utf-8

require File.join(File.dirname(__FILE__), "/../test_helper")

class UnusedStyleOptsTest < Test::Unit::TestCase

  context "A Unused Style Tool Options Parser" do

    should "return default hash if no arguments are specified" do

      args = []
      opts = UnusedStyleOpts.parse(args)

      assert_equal 'styles.txt', opts[:output]
      assert_equal 'style', opts[:css_dir]
      assert_equal '.', opts[:src]
      assert_equal false, opts[:verbose]

    end

    should "display a name" do
      assert_match(/\w+/, UnusedStyleOpts.name)
    end

    should "describe itself" do
      assert_match(/\w+/, UnusedStyleOpts.description)
    end

  end

end
