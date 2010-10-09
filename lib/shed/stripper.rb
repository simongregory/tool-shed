# encoding: utf-8

module Stripper

  class << self

    #
    # Strips xml comments from the document.
    #
    def xml_comments(str)
      str.gsub!(/<!--(?:.|([\r\n]))*?-->/,'')
      str.gsub(/<!--.*-->/,'')
      str
    end

    #
    # Strips comments from the document.
    #
    def ecma_comments(str)

      str.gsub!(/\/\*(?:.|([\r\n]))*?\*\//,'')

      # This is designed to leave whitespace in
      # place so the caret position remains correct.
      #do |s|
      #  if $1
      #    a = s.split("\n")
      #    r = "\n" * (a.length-1) if a.length > 1
      #    r
      #  end
      #end

      str.gsub!(/\/\/.*$/,'')
      str

    end

    #
    # Strips both xml and ecma script comments.
    #
    def comments(str)
      str = xml_comments(str)
      str = ecma_comments(str)
      str
    end

  end

end
