# encoding: utf-8

require File.join(File.dirname(__FILE__), "/../test_helper")

class TestUnusedStyle < Test::Unit::TestCase

  def fix
    File.expand_path(File.dirname(__FILE__)+ "/../fixtures/unused-css")
  end

  context "A  unused style detector" do

    context "with correct arguments" do
      setup do
        opt = { :src => "#{fix}/src",
                :css_dir => "#{fix}/css" }

        @out = StringIO.new
        @tool = UnusedStyle.new(opt,@out)
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
      setup do
        opt = { :src => "#{fix}/src",
                :css_dir => "#{fix}/src" }

        @out = StringIO.new
        @tool = UnusedStyle.new(opt,@out)
      end

      should "fail with a warning message" do
        assert_match(/#{UnusedStyle::INVALID_OPTS}/, @out.string)
        assert_equal(false, @tool.valid_opts)
      end
    end

    context "when given a css directory containing more than one css" do
      setup do
        opt = { :src => "#{fix}/src",
                :css_dir => "#{fix}/css-multiple" }

        @tool = UnusedStyle.new(opt)
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
                :css_dir => "#{fix}/css-with-comments" }

        @tool = UnusedStyle.new(opt)
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
                :css_dir => "#{fix}/css" }

        @tool = UnusedStyle.new(opt)
      end

      should "find all values of syleName attributes" do
        assert @tool.used.length == 2
      end

    end

  end

end
