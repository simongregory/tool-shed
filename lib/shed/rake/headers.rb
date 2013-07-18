# encoding: utf-8

module FlexHeaders
  class Task < Rake::TaskLib
    attr_writer :paths

    def copyright=(value)
      make_header(value)
    end

    def initialize name = :headers
      @name = name
      @paths = 'src,test'
      @header = make_header

      yield self if block_given?

      define
    end

    def define
      desc "Updates all ActionScript source files to include copyright headers"
      task @name do
        Dir[ "{#{@paths}}/**/*.as" ].each do |uri|
          src = IO.read( uri )
          File.open( uri, 'w+' ) do |f|
            f << src.sub( /.*?(?=package)/m, @header )
          end
        end
        puts "Added copyright header to all .as files"
      end
    end

    private

    def make_header(rights=default_rights)
      @header = as3_header.sub('[COPYRIGHT]', rights)
    end

    def default_rights
      "Copyright #{Time.new().year} the original author or authors."
    end

    def as3_header
  %{//AS3///////////////////////////////////////////////////////////////////////////
//
// [COPYRIGHT]
//
////////////////////////////////////////////////////////////////////////////////

}
    end
  end
end

def headers *args, &block
  FlexHeaders::Task.new *args, &block
end
