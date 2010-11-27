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
        assert_match(/\.gif/, @tool.assets.to_s)
        assert_match(/\.jpg/, @tool.assets.to_s)
        assert_match(/\.mp3/, @tool.assets.to_s)
        assert_match(/\.otf/, @tool.assets.to_s)
        assert_match(/\.png/, @tool.assets.to_s)
        assert_match(/\.svg/, @tool.assets.to_s)
        assert_match(/\.swf/, @tool.assets.to_s)
        assert_match(/\.ttf/, @tool.assets.to_s)
        assert_equal(17, @tool.assets.length)
      end

      should "search all loaded src files for asset references and store them in a list" do
        assert_match('referenced.gif', @tool.declared.to_s)
        assert_match('referenced.jpg', @tool.declared.to_s)
        assert_match('referenced.mp3', @tool.declared.to_s)
        assert_match('referenced.otf', @tool.declared.to_s)
        assert_match('referenced.png', @tool.declared.to_s)
        assert_match('referenced.svg', @tool.declared.to_s)
        assert_match('referenced.swf', @tool.declared.to_s)
        assert_match('referenced-in-css.swf', @tool.declared.to_s)
        assert_match('referenced-in-css.ttf', @tool.declared.to_s)
        assert_match('referenced-in-unused-css.ttf', @tool.declared.to_s)
        assert_equal(10, @tool.declared.length)
      end

      should "produce a list of assets found in the project directory which are not referenced in the project src" do
        assert_match('un-referenced.jpg', @tool.unused.to_s)
        assert_match('un-referenced.gif', @tool.unused.to_s)
        assert_match('un-referenced.mp3', @tool.unused.to_s)
        assert_match('un-referenced.otf', @tool.unused.to_s)
        assert_match('un-referenced.png', @tool.unused.to_s)
        assert_match('un-referenced.svg', @tool.unused.to_s)
        assert_match('un-referenced.swf', @tool.unused.to_s)
        assert_equal(7, @tool.unused.length)
      end

      should "only search css files referenced in as/mxml for asset references" do
        #Tecnically yes. Sounds like a pain in the ass to me though.
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
