# encoding: utf-8

require File.join(File.dirname(__FILE__), "/../test_helper")

class TestUnusedAsset < Test::Unit::TestCase

  def fix
    File.expand_path(File.dirname(__FILE__)+ "/../fixtures/unused-asset")
  end

  context "A unused asset detector" do

    context "with correct arguments" do
      setup do
        opt = { :src => "#{fix}/src",
                :css_dir => "#{fix}/assets" }

        @out = StringIO.new
        @tool = UnusedAsset.new(opt,@out)
      end

      should "find all assets in the project" do
        #store list
      end

      should "load all src files in the project" do
        #css
        #mxml
        #as
      end

      should "search all loaded src files for asset references and store them in a list" do
        #store list
      end

      should "produce a list of assets found in the project which are not referenced in the project src" do
        #print list..
      end

      should "load the project link report and look for assets compiled into the application" do

      end

    end

    context "with incorrect arguments" do
      setup do
        opt = {:manifest => "INVALID", :output => '/tmp/unused-asset-tool.txt'}
        @out = StringIO.new
        @tool = UnusedClass.new(opt,@out)
      end

      should "fail with a warning message" do
        assert_match(/#{UnusedClass::INVALID_OPTS}/, @out.string)
      end
    end
  end

end
