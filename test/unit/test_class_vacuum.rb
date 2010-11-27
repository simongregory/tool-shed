# encoding: utf-8

require File.join(File.dirname(__FILE__), "/../test_helper")

class TestClassVacuum < Test::Unit::TestCase

  context "A class vacuum tool" do

    context "with correct arguments" do
      setup do
        fix = File.expand_path(File.dirname(__FILE__)+ "/../fixtures/unused-cla")
        opt = { :src => "#{fix}/src",
                :manifest => "#{fix}/manifest.xml",
                :link_report => "#{fix}/link-report.xml",
                :output => '/tmp/as-class-vacuum.txt' }

        @out = StringIO.new
        @tool = ClassVacuum.new(opt,@out)
      end

      should "find unused classes" do
        assert @tool.unused_classes.length == 1
        assert @tool.unused_classes[0] == 'UnusedClass'
      end

      should "find empty packages" do
        assert @tool.empty_packages.length > 0
        assert_equal('org/helvector', @tool.empty_packages[0])
      end

      should "have valid options" do
        assert @tool.valid_opts
      end
    end

    context "with incorrect arguments" do
      setup do
        opt = {:manifest => "INVALID", :output => '/tmp/as-class-vacuum.txt'}
        @out = StringIO.new
        @tool = ClassVacuum.new(opt,@out)
      end

      should "fail with a warning message" do
        assert_match(/#{ClassVacuum::INVALID_OPTS}/, @out.string)
      end
    end

  end

end
