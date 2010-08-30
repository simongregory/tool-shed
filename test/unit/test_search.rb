# encoding: utf-8

require File.join(File.dirname(__FILE__), "/../test_helper")

class SearchTest < Test::Unit::TestCase

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
      assert_equal(4, @found.length)
      assert_match(/(b|x|z)org/, @found.to_s)
    end

    should "list all directories in a sub tree that are empty but skipping specified exclusions" do
      Search.for_empties(@path, ['org']) { |f| @found << f }
      assert_equal(3, @found.length)
      assert_match(/(b|x|z)org/, @found.to_s)
    end

  end

end