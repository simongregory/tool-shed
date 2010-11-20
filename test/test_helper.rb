# encoding: utf-8

$:.push File.join(File.dirname(__FILE__), "..", "lib")
$:.push File.dirname(__FILE__)

require 'tool_shed'
require 'bundler'

Bundler.require :development

#Create empty directories for the unit tests, as Git ignores empty directories.
empties = ['test/fixtures/empty/borg',
           'test/fixtures/empty/org',
           'test/fixtures/empty/xorg',
           'test/fixtures/empty/zorg',
           'test/fixtures/unused-cla/src/org']

empties.each { |f|
  `mkdir -p #{f}` unless File.exists?("#{f}")
}
