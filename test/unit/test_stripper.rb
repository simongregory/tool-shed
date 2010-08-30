# encoding: utf-8

require File.join(File.dirname(__FILE__), "/../test_helper")

class StripperTest < Test::Unit::TestCase

  context "Comment stripper" do

    should "remove single line xml comments from a string" do

      s = "<!--single-line-->"
      s = Stripper.xml_comments(s)

      assert s.empty?

    end

    should "remove multi line xml comments from a string" do

      s = "\n\n<!--\nmulti-line\n-->\n"
      s = Stripper.xml_comments(s)

      assert_equal(s, "\n\n\n")

    end

    should "remove single line ecma script comments" do

      s = "//single-line"
      s = Stripper.ecma_comments(s)

      assert s.empty?

    end

    should "remove multi line ecma script comments" do

      s = "\n\n/*\nmulti-line\n*/\n"
      s = Stripper.ecma_comments(s)

      assert_equal(s, "\n\n\n")

    end

    should "remove multi and single line ecma script and xml comments" do

      s = "\n/*\nmulti-line\n*/\n<!--single-line-->\n//single-line\n<!--\nmulti-line\n-->\n"
      s = Stripper.comments(s)

      assert_equal(s, "\n\n\n\n\n")

    end

  end

end
