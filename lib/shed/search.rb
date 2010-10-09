# encoding: utf-8

#
# Collection of methods for searching directories.
#
module Search

  require 'find'

  #
  # Searches a directory and it's child directories for all the files whose
  # names match the specified regular expression.
  #
  def self.find_all(files_of_type,dir,excluding=[])

    Find.find(dir) do |path|
      if FileTest.directory?(path)

        if excluding.include?(File.basename(path))
          Find.prune
        else
          next
        end

      elsif File.extname(path) =~ files_of_type
        yield path
      end
    end
  end

  #
  # Scans the path and its children for empty directories.
  #
  def self.for_empties(path,excluding=[])

    Find.find(path) do |p|

      if FileTest.directory?(p)
        if excluding.include?(File.basename(p))
          Find.prune
        else
          # Any dir that only contains ., .., and .svn or .git are empty.
          yield p if Dir.entries(p).join =~ /^\.\.\.(\.(svn|git))?$/
        end
      end

    end

  end
end