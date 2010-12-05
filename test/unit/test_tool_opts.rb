# encoding: utf-8

require File.join(File.dirname(__FILE__), "/../test_helper")

class TestToolOpts < Test::Unit::TestCase

  context "A  Tool Options Parser" do

    should "return default hash if no arguments are specified" do

      args = []
      opts = ToolOpts.parse(args)

      assert_equal 'output.xml', opts[:output]
      assert_equal '.', opts[:src]
      assert_equal false, opts[:verbose]

    end

    should "recognise default arguments if no switches are present" do
      args = ['path/to/a/text.file']
      opts = ToolOpts.parse(args)

      assert_equal 'path/to/a/text.file', opts[:default]
    end

    should "recognise default arguments when switches are present" do
      args = ['-v','path/to/a/text.file', '-s', 'path/to/source']
      opts = ToolOpts.parse(args)

      assert_equal 'path/to/a/text.file', opts[:default]
      assert opts[:verbose]
    end

    should "define verbose mode when -v is set" do
      args = ['-v']
      opts = ToolOpts.parse(args)

      assert opts[:verbose]
    end

    should "set source when -s or --source is specified" do

      path = '/dummy/path'
      args = ['-s', path]
      opts = ToolOpts.parse(args)

      assert_equal path, opts[:src]

      args = ['--source', path]
      opts = ToolOpts.parse(args)

      assert_equal path, opts[:src]

    end

    should "display a help message" do
      begin
        out = StringIO.new
        args = ['-h']
        opts = ToolOpts.parse(args,out)
      rescue SystemExit => e
        assert_equal 0, e.status
        assert_match(/Usage/, out.string)
      end
    end

    should "display version information" do
      begin
        out = StringIO.new
        args = ['--version']
        opts = ToolOpts.parse(args,out)
      rescue SystemExit => e
        assert_equal 0, e.status
        assert_match(/version/, out.string)
        assert_match(/\d/, out.string)
      end
    end

    should "display a name" do
      assert_match(/\w+/, ToolOpts.name)
    end

    should "describe itself" do
      assert_match(/\w+/, ToolOpts.description)
    end

    should "show a version number" do
      assert_match(/\d+/, ToolOpts.version)
    end

  end

end
