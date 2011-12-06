# encoding: utf-8

module ActionScriptVersion
  class Task < Rake::TaskLib
    attr_accessor :major,
                  :minor,
                  :patch,
                  :template,
                  :strip_xml_comments,
                  :output

    def initialize name = :version
      @name = name
      @output = 'Version.as'
      @strip_xml_comments = false

      yield self if block_given?

      define
    end

    def define
      desc "Generate a ActionScript class containing application version details"
      task @name do
        revision = `git rev-parse HEAD`.chomp rescue 'no-git-rev'
        t = File.read(@template)
        t.gsub!('@major@', major.to_s)
        t.gsub!('@minor@', minor.to_s)
        t.gsub!('@patch@', patch.to_s)
        t.gsub!('@revision@', revision)
        t = Stripper.xml_comments(t) if @strip_xml_comments

        File.open(@output, 'w') {|f| f.write(t) }

        puts "Created #{output}, v#{major}.#{minor}.#{patch} [#{revision[0..10]}]"
      end
    end

    private

    def to_hash
      {
        :major => major, :minor => minor, :patch => patch, :template => template, :output => output
      }
    end
  end
end

def version *args, &block
  ActionScriptVersion::Task.new *args, &block
end
