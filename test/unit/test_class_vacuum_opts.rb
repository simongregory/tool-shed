# encoding: utf-8

require File.join(File.dirname(__FILE__), "/../test_helper")

class TestClassVacuumOpts < Test::Unit::TestCase

  context "A Class Vacuum Tool Options Parser" do

    should "return default hash if no arguments are specified" do
      args = []
      opts = ClassVacuumOpts.parse(args)

      assert_equal 'class-vacuum.txt', opts[:output]
      assert_equal 'manifest.xml', opts[:manifest]
      assert_equal 'link-report.xml', opts[:link_report]
      assert_equal '.', opts[:src]
      assert_equal false, opts[:verbose]
    end

    should "display a name" do
      assert_match(/\w+/, ClassVacuumOpts.name)
    end

    should "describe itself" do
      assert_match(/\w+/, ClassVacuumOpts.description)
    end

    should "raise an exception if mandatory arguments are missing" do
      assert_raise(OptionParser::MissingArgument) { ClassVacuumOpts.parse(['-m']) }
      assert_raise(OptionParser::MissingArgument) { ClassVacuumOpts.parse(['--manifest']) }
      assert_raise(OptionParser::MissingArgument) { ClassVacuumOpts.parse(['-l']) }
      assert_raise(OptionParser::MissingArgument) { ClassVacuumOpts.parse(['--link-report']) }
    end

    should "raise an exception if incorrect arguments are specified" do
      assert_raise(OptionParser::InvalidOption) { ClassVacuumOpts.parse(['-z']) }
      assert_raise(OptionParser::InvalidOption) { ClassVacuumOpts.parse(['--kapow']) }
      assert_raise(OptionParser::InvalidOption) { ClassVacuumOpts.parse(['--shlock']) }
    end

    should "set manifest and link-report properties" do
      args = ['-m', 'custom-manifest.xml', '-l', 'custom-link-report.xml']
      opts = ClassVacuumOpts.parse(args)

      assert_equal 'custom-manifest.xml', opts[:manifest]
      assert_equal 'custom-link-report.xml', opts[:link_report]
    end

  end

end
