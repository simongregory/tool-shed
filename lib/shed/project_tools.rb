# encoding: utf-8

#
# A collection of utility methods to help working with ActionScript source.
#
class ProjectTools

  #
  # Returns an array of directory names that are commonly used
  # as the root directory for source files.
  #
  def self.common_src_dirs
    ['src','source','test','lib']
  end

  #
  # Takes a file path and truncates it to the last matching conventionally named
  # source directory.
  #
  def self.truncate_to_src(path)
    common_src_dirs.each do |remove|
      path = path.gsub(/^.*\b#{remove}\b(\/|$)/, '');
    end
    path
  end

  #
  # Removes any relative prefixes found in the provided path.
  #
  def self.remove_relative_prefix(path)
    path.sub(/^\W+\b/, '')
  end

  #
  # Takes a file path and converts it to a package path using conventionally
  # named source folders as the root marker.
  #
  def self.package(path)
    path = remove_relative_prefix(path)
    path = File.dirname(path) if path =~ flex_file_regx
    truncate_to_src(path).gsub('/','.')
  end

  #
  # Takes a file path and converts it to a import path using conventionally
  # named source folders as the root marker.
  #
  def self.import(path)
    truncate_to_src(path).gsub('/','.').sub(flex_file_regx,'')
  end

  #
  # Regular expression to match files we expect to find in a ActionScript/Flex
  # project.
  #
  def self.flex_file_regx
    /\.(as|mxml|asdoc|fxg)$/
  end

end
