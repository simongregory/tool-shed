# encoding: utf-8

require File.join(File.dirname(__FILE__), "/../test_helper")

class ManifestTest < Test::Unit::TestCase

  context "A manifest builder tool" do

    setup do
      @output = '/tmp/hel-as-manifest-tool-test.xml'
      src  = File.expand_path(File.dirname(__FILE__)+ "/../fixtures/src")
      opts = ManifestOpts.parse ['-s', src,'-o', @output, '--silent']
      @manf = Manifest.new(opts)
    end

    teardown do
      File.delete @output
    end

    should "find all actionscript and .mxml files in src tree" do

      assert_equal(false, @manf.xml.empty?)
      assert((@manf.components.length > 1))
      assert((@manf.components.length == 5))

      assert_match(/org\.helvector\.one\.HelOneTwo/, @manf.xml)
      assert_match(/org\.helvector\.one\.HelOne/, @manf.xml)
      assert_match(/org\.helvector\.three\.HelThree/, @manf.xml)
      assert_match(/org\.helvector\.Helvector/, @manf.xml)

    end

    should "write the results to disk" do
      assert File.exist?(@output)
    end

  end

  context "A manifest builder tool invoked on a empty directory" do
    setup do
      @output = '/tmp/hel-as-manifest-tool-test.xml'
      src  = File.expand_path(File.dirname(__FILE__)+ "/../fixtures/empty")
      opts = ManifestOpts.parse ['-s', src,'-o', @output]
      @out = StringIO.new
      @manf = Manifest.new(opts,@out)
    end

    should "not find any files" do
      assert_match(/No.*files found\./, @out.string)
    end
  end

end
