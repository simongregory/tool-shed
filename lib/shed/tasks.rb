require 'rake'
require 'rake/tasklib'

class HeadersTask < Rake::TaskLib

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
          f << src.sub( /.+?(?=package)/m, @header )
        end
      end
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

class ManifestTask < Rake::TaskLib
  attr_accessor :filter,
                :src,
                :output,
                :silent

  def initialize name = :manifest
    @name = name
    @output = 'manifest.xml'
    @filter = ''
    @silent = true

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
