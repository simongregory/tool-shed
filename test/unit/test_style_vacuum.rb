# encoding: utf-8

require File.join(File.dirname(__FILE__), "/../test_helper")

class TestStyleVacuum < Test::Unit::TestCase

  def fix
    File.expand_path(File.dirname(__FILE__)+ "/../fixtures/unused-css")
  end

  context "A style vacuum tool" do

    context "with correct arguments" do

      setup do
        opt = { :src => "#{fix}/src",
                :css_dir => "#{fix}/css",
                :output => '/tmp/as-style-vacuum.txt' }

        @out = StringIO.new
        @tool = StyleVacuum.new(opt,@out)
      end

      should "find declared styles" do
        assert @tool.declared.length == 2
      end

      should "find unused styles" do
        assert @tool.unused.length == 1
      end

      should "have valid options" do
        assert_not_equal("The required options were not specified\n", @out.string)
        assert @tool.valid_opts
      end

    end

    context "with incorrect arguments" do

      should "fail with a warning message" do
        opt = { :src => "#{fix}/src", :css_dir => "#{fix}/src",
                :output => '/tmp/as-style-vacuum.txt' }
        out = StringIO.new

        begin
          StyleVacuum.new(opt,out)
          flunk
        rescue SystemExit => e
          assert_equal 0, e.status
          assert_match(/#{Tool::INVALID_OPTS} The specified/, out.string)
        end
      end

    end

    context "when given a css directory containing more than one css" do

      setup do
        opt = { :src => "#{fix}/src",
                :css_dir => "#{fix}/css-multiple",
                :output => '/tmp/as-style-vacuum.txt' }

        @out = StringIO.new
        @tool = StyleVacuum.new(opt,@out)
      end

      should "find declared styles" do
        assert @tool.declared.length == 4
      end

      should "find unused styles" do
        assert @tool.unused.length == 3
      end

    end

    context "when searching css files for style definitions" do

      setup do
        opt = { :src => "#{fix}/src",
                :css_dir => "#{fix}/css-with-comments",
                :output => '/tmp/as-style-vacuum.txt' }

        @out = StringIO.new
        @tool = StyleVacuum.new(opt,@out)
      end

      should "find basic declarations" do
        assert @tool.declared.include? 'moreUsedStyle'
        assert @tool.declared.include? 'moreUnUsedStyle'
      end

      should "ignore declarations that are commented out" do
        assert_equal(false, @tool.declared.include?('aCommentedOutStyle'))
      end

    end

    context "when searching mxml documents for style useage" do

      setup do
        opt = { :src => "#{fix}/src",
                :css_dir => "#{fix}/css",
                :output => '/tmp/as-style-vacuum.txt' }

        @out = StringIO.new
        @tool = StyleVacuum.new(opt,@out)
      end

      should "find all values of syleName attributes" do
        assert @tool.used.length == 2
      end

    end

  end

end
