# encoding: utf-8

require File.join(File.dirname(__FILE__), "/../test_helper")

class TestStyleVacuumOpts < Test::Unit::TestCase

  context "A Style Vacuum Tool Options Parser" do

    should "return default hash if no arguments are specified" do
      args = []
      opts = StyleVacuumOpts.parse(args)

      assert_equal 'styles.txt', opts[:output]
      assert_equal 'style', opts[:css_dir]
      assert_equal '.', opts[:src]
      assert_equal false, opts[:verbose]
    end

    should "display a name" do
      assert_match(/\w+/, StyleVacuumOpts.name)
    end

    should "describe itself" do
      assert_match(/\w+/, StyleVacuumOpts.description)
    end

    should "raise an exception if mandatory arguments are missing" do
      assert_raise(OptionParser::MissingArgument) { StyleVacuumOpts.parse(['--css']) }
    end

    should "raise an exception if incorrect arguments are specified" do
      assert_raise(OptionParser::InvalidOption) { StyleVacuumOpts.parse(['--ccs']) }
      assert_raise(OptionParser::InvalidOption) { StyleVacuumOpts.parse(['--zaaap']) }
      assert_raise(OptionParser::InvalidOption) { StyleVacuumOpts.parse(['--vrrooom']) }
    end

    should "set manifest and link-report properties" do
      args = ['--css', 'custom/ccs/directory']
      opts = StyleVacuumOpts.parse(args)

      assert_equal 'custom/ccs/directory', opts[:css_dir]
    end

  end

end
