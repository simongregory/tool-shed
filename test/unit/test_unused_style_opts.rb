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

    should "raise an exception if mandatory arguments are missing" do
      assert_raise(OptionParser::MissingArgument) { UnusedStyleOpts.parse(['--css']) }
    end

    should "raise an exception if incorrect arguments are specified" do
      assert_raise(OptionParser::InvalidOption) { UnusedStyleOpts.parse(['--ccs']) }
      assert_raise(OptionParser::InvalidOption) { UnusedStyleOpts.parse(['--zaaap']) }
      assert_raise(OptionParser::InvalidOption) { UnusedStyleOpts.parse(['--vrrooom']) }
    end

    should "set manifest and link-report properties" do
      args = ['--css', 'custom/ccs/directory']
      opts = UnusedStyleOpts.parse(args)

      assert_equal 'custom/ccs/directory', opts[:css_dir]
    end

  end

end
