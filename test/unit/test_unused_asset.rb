# encoding: utf-8

require File.join(File.dirname(__FILE__), "/../test_helper")

class TestUnusedAsset < Test::Unit::TestCase

  def fix
    File.expand_path(File.dirname(__FILE__)+ "/../fixtures/unused-asset")
  end

  context "A unused asset detector" do

    context "with correct arguments" do
      setup do
        opt = { :project_dir => "#{fix}",
                :output => "/tmp/as-unused-asset-tool.txt" }

        @out = StringIO.new
        @tool = UnusedAsset.new(opt,@out)
      end

      should "find all assets in the project" do
        assert_equal(6, @tool.assets.length)
        assert_match(/\.jpg/, @tool.assets.to_s)
        assert_match(/\.png/, @tool.assets.to_s)
        assert_match(/\.otf/, @tool.assets.to_s)
      end

      should "search all loaded src files for asset references and store them in a list" do
        assert_equal(3, @tool.declared.length)
        assert_match('referenced.otf', @tool.declared.to_s)
        assert_match('referenced.jpg', @tool.declared.to_s)
        assert_match('referenced.png', @tool.declared.to_s)
      end

      should "produce a list of assets found in the project directory which are not referenced in the project src" do
        assert_equal(3, @tool.unused.length)
        assert_match('un-referenced.otf', @tool.unused.to_s)
        assert_match('un-referenced.jpg', @tool.unused.to_s)
        assert_match('un-referenced.png', @tool.unused.to_s)
      end

      should "load the project link report and look for assets compiled into the application" do
        #TODO
        #flunk
      end

    end

    context "with incorrect arguments" do
      setup do
        opt = {:project_dir => "INVALID", :output => "/tmp/as-unused-asset-tool.txt"}
        @out = StringIO.new
        @tool = UnusedAsset.new(opt,@out)
      end

      should "fail with a warning message" do
        assert_match(/#{UnusedAsset::INVALID_OPTS}/, @out.string)
      end
    end
  end

end
