# encoding: utf-8

require File.join(File.dirname(__FILE__), "/../test_helper")

class ToolTest < Test::Unit::TestCase

  context "A default hel-tool" do

    setup do
      @out = StringIO.new
      @tool = Tool.new({:output => '/tmp/hel-tool.txt'},@out)
    end

    should "puts messages" do
      @tool.puts 'hello'
      assert_equal("hello\n", @out.string)
    end

    should "not log messages" do
      @tool.log 'hello'
      assert_equal('', @out.string)
    end

    should "have valid options" do
      assert @tool.valid_opts
    end

    should "provide a 'generated at' time stamp" do
      assert_match(/Generated at/, @tool.generated_at)
      assert_match(/\d\d:\d\d:\d\d/, @tool.generated_at)
    end

  end

  context "A silent hel-tool" do

    setup do
      @out = StringIO.new
      @tool = Tool.new({:silent => true, :output => '/tmp/hel-tool.txt'}, @out)
    end

    should "not puts messages" do
      @tool.puts 'hello'
      assert @out.string.empty?
    end

    should "not log messages" do
      @tool.log 'hello'
      assert @out.string.empty?
    end

  end

  context "A verbose hel-tool" do
    setup do
      @out = StringIO.new
      @tool = Tool.new({:verbose => true, :output => '/tmp/hel-tool.txt'}, @out)
    end

    should "puts messages" do
      @tool.puts 'hello'
      assert_equal("hello\n", @out.string)
    end

    should "not log messages" do
      @tool.log 'hello'
      assert_equal("hello\n", @out.string)
    end

  end

end

