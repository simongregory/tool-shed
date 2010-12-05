# encoding: utf-8

require File.join(File.dirname(__FILE__), "/../test_helper")

class TestSourceTools < Test::Unit::TestCase

  context "Utility source tools" do

    should "truncate file paths to their source directory" do

      p = 'a/b/src/com'
      assert_equal('com', ProjectTools.truncate_to_src(p))

      p = '/a/b/source/c/src/test/org/helvector/io'
      assert_equal('org/helvector/io', ProjectTools.truncate_to_src(p))

      p = '/a/b/source/org/helvector/io'
      assert_equal('org/helvector/io', ProjectTools.truncate_to_src(p))

      p = '/a/b/source/lib/tools/src/org/helvector/io'
      assert_equal('org/helvector/io', ProjectTools.truncate_to_src(p))

    end

    should "convert an absolute file path to a package declaration" do

      p = '/a/b/source/org/helvector/io'
      assert_equal('org.helvector.io', ProjectTools.package(p))

      p = '/a/b/source/c/src/test/org/helvector/io'
      assert_equal('org.helvector.io', ProjectTools.package(p))

      p = '/a/b/c/test/org/helvector/io/Vector.as'
      assert_equal('org.helvector.io', ProjectTools.package(p))

    end

    should "convert a relative file path to a package declaration" do

      p = 'a/b/src/com'
      assert_equal('com', ProjectTools.package(p))

      p = 'a/b/source/lib/tools/src/org/helvector/io'
      assert_equal('org.helvector.io', ProjectTools.package(p))

      p = 'a/b/source/lib/tools/src/org/helvector/io/Test.as'
      assert_equal('org.helvector.io', ProjectTools.package(p))

      p = 'a/b/source/lib/tools/src/org/helvector/io/Test.mxml'
      assert_equal('org.helvector.io', ProjectTools.package(p))

      p = './org/helvector/io/Test.mxml'
      assert_equal('org.helvector.io', ProjectTools.package(p))

      p = '../../org/helvector/io/Test.mxml'
      assert_equal('org.helvector.io', ProjectTools.package(p))

      p = 'org/helvector/io/Test.mxml'
      assert_equal('org.helvector.io', ProjectTools.package(p))

    end

    should "convert an absolute file path to an import declaration" do

      p = '/a/b/source/c/src/test/org/helvector/io/Foo.mxml'
      assert_equal('org.helvector.io.Foo', ProjectTools.import(p))

      p = '/a/b/source/org/helvector/io/Bar.as'
      assert_equal('org.helvector.io.Bar', ProjectTools.import(p))

      p = '/a/b/source/lib/tools/src/org/helvector/io'
      assert_equal('org.helvector.io', ProjectTools.import(p))

    end

    should "convert a relative file path to an import declaration" do

      p = 'a/b/src/com/Hello.as'
      assert_equal('com.Hello', ProjectTools.import(p))

      p = 'a/b/source/lib/tools/src/org/helvector/io/Test.as'
      assert_equal('org.helvector.io.Test', ProjectTools.import(p))

      p = 'a/b/source/lib/tools/src/org/helvector/io/Test.mxml'
      assert_equal('org.helvector.io.Test', ProjectTools.import(p))

      p = './a/b/source/lib/tools/src/org/helvector/io/Test.mxml'
      assert_equal('org.helvector.io.Test', ProjectTools.import(p))

      p = './../../a/b/source/lib/tools/src/org/helvector/io/Test.mxml'
      assert_equal('org.helvector.io.Test', ProjectTools.import(p))

    end

  end

end
