# encoding: utf-8

require File.join(File.dirname(__FILE__), "/../test_helper")

class ASDocPackageTest < Test::Unit::TestCase

  context "An ASDdoc Package Tool" do

    setup do
      @out = '/tmp/asdoc-package-tool-test-output.xml'
      src  = File.expand_path(File.dirname(__FILE__)+ "/../fixtures/src")
      opts = ASDocPackageOpts.parse ['-s', src,'-o', @out, '--silent']
      @pack = ASDocPackage.new(opts)
    end

    teardown do
      File.delete(@out)
      @out = nil
      @pack = nil
    end

    should "find .asdoc files in src directories" do
      assert_not_nil(@pack.xml)
      assert_equal(false, @pack.xml.empty?)

      assert_match(/<flex-config>/, @pack.xml)
      assert_match(/Package One/, @pack.xml)
      assert_match(/Package Two/, @pack.xml)
      assert_match(/Package Three/, @pack.xml)
    end

    should "output the results to a file" do
      assert File.exist? @out
    end

  end

  context "A ASDocPackage tool should skip specified directories" do
    setup do
      src  = File.expand_path(File.dirname(__FILE__)+ "/../fixtures/src")
      opts = { :verbose => true,
               :src => src,
               :output => '/tmp/asdoc-package-tool-test-output.xml',
               :excludes => ['one'],
               :silent => true }

      @pack = ASDocPackage.new(opts)
    end

    should "not search excluded directories" do
      assert_not_nil(@pack.xml)
      assert_equal(false, @pack.xml.empty?)
      p = @pack.xml =~ /Package One/ ? true : false
      assert_equal(false,p)
    end
  end

  context "A asdoc package builder tool invoked on a empty directory" do
    setup do
      @output = '/tmp/hel-as-manifest-tool-test.xml'
      src  = File.expand_path(File.dirname(__FILE__)+ "/../fixtures/empty")
      opts = ASDocPackageOpts.parse ['-s', src,'-o', @output]
      @out = StringIO.new
      @manf = ASDocPackage.new(opts,@out)
    end

    should "not find any files" do
      assert_match(/No.*files found\./, @out.string)
    end
  end

end
