# encoding: utf-8

require File.join(File.dirname(__FILE__), "/../test_helper")

class TestSearch < Test::Unit::TestCase

  context "A file search utility" do

    setup do
      @path = File.expand_path(File.dirname(__FILE__)+ "/../fixtures/search")
      @found = []
    end

    should "find all files with the specified extensions" do

      Search.find_all(/\.(as|mxml)$/,@path) { |f| @found << f }

      assert_equal(3, @found.length)
      assert_match(/App\.mxml/, @found.to_s)
      assert_match(/Main\.as/, @found.to_s)
      assert_match(/Hidden\.as/, @found.to_s)

    end

    should "find only find files with a specific extension" do

      Search.find_all(/\.as$/,@path) { |f| @found << f }

      assert_equal(2, @found.length)
      assert_match(/Main\.as/, @found.to_s)
      assert_match(/Hidden\.as/, @found.to_s)

    end

    should "not search directories specified in the exclude list" do

      Search.find_all(/\.(as|mxml)$/,@path,['hide']) { |f| @found << f }

      assert_equal(2, @found.length)
      assert_match(/App\.mxml/, @found.to_s)
      assert_match(/Main\.as/, @found.to_s)

    end

  end

  context "A empty directory search" do
    setup do
      @path = File.expand_path(File.dirname(__FILE__)+ "/../fixtures/empty")
      @found = []
    end

    should "list all directories in a sub tree that are empty" do
      Search.for_empties(@path) { |f| @found << f }

      assert_match(/\/borg/, @found.to_s)
      assert_match(/\/xorg/, @found.to_s)
      assert_match(/\/zorg/, @found.to_s)
      assert_match(/\/org/, @found.to_s)
      assert_match(/\/git/, @found.to_s)
      assert_match(/\/svn/, @found.to_s)

      assert_equal(6, @found.length)
    end

    should "skip specified exclusions when searching for empty directories" do
      Search.for_empties(@path, ['org', 'git', 'zorg']) { |f| @found << f }

      assert_equal(3, @found.length)
    end

    context "finds hidden directories by default" do

      should "not recurse into svn directories" do
        Search.for_empties(@path) { |f| @found << f }

        assert_equal(6, @found.length)
      end

      should "not recurse into git directories" do
        Search.for_empties(@path) { |f| @found << f }

        assert_equal(6, @found.length)
      end
    end
  end

end