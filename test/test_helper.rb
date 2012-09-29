# encoding: utf-8

require 'bundler'
Bundler.require :default, :development

lib = File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'lib'))
$:.unshift lib unless $:.include? lib

test = File.expand_path(File.join(File.dirname(__FILE__), '..'))
$:.unshift test unless $:.include? test

require 'tool_shed'

#Create empty directories for the unit tests, as Git ignores empty directories.
empties = ['test/fixtures/empty/borg',
           'test/fixtures/empty/org',
           'test/fixtures/empty/xorg',
           'test/fixtures/empty/zorg',
           'test/fixtures/unused-cla/src/org',
           'test/fixtures/empty/svn/a',
           'test/fixtures/empty/git/b/c']

empties.each { |f|
  FileUtils.mkdir_p(f) unless File.exists?("#{f}")
}
