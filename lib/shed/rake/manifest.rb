# encoding: utf-8

module FlexManifest
  class Task < Rake::TaskLib
    attr_accessor :filter,
                  :src,
                  :output,
                  :silent

    def initialize name = :manifest
      @name = name
      @output = 'manifest.xml'
      @filter = ''
      @silent = false

      yield self if block_given?

      define
    end

    def define
      desc "Generate a manifest file "
      task @name do
        Manifest.new(to_hash)
      end
    end

    private

    def to_hash
      { :filter => filter, :src => src, :output => output, :silent => silent }
    end
  end
end

def manifest *args, &block
  FlexManifest::Task.new *args, &block
end
