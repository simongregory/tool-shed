# encoding: utf-8

require File.join(File.dirname(__FILE__), "/../test_helper")

class UnusedClassOptsTest < Test::Unit::TestCase

  context "A Unused Class Tool Options Parser" do

    should "return default hash if no arguments are specified" do

      args = []
      opts = UnusedClassOpts.parse(args)

      assert_equal 'class-vaccum.txt', opts[:output]
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

    should "raise an exception if mandatory arguments are missing" do
      #TODO assert_raise(Exception) { UnusedClassOpts.parse([]) }
    end

    should "exit with a useage message if mandatory options are not specified" do
      #TODO: This is failing as the rescue is never entered.
      #rescued = false;
      #begin
      #  out = StringIO.new
      #  args = []
      #  opts = UnusedClassOpts.parse(args,out)
      #rescue SystemExit => e
      #  assert_equal 0, e.status
      #  assert_match(/Usage/, out.string)
      #  rescued = true
      #end
      #flunk() unless rescued
    end

    should "set manifest and link-report properties" do
      args = ['-m', 'custom-manifest.xml', '-l', 'custom-link-report.xml']
      opts = UnusedClassOpts.parse(args)

      assert_equal 'custom-manifest.xml', opts[:manifest]
      assert_equal 'custom-link-report.xml', opts[:link_report]
    end

  end

end
