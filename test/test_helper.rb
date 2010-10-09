# encoding: utf-8

$:.push File.join(File.dirname(__FILE__), "..", "lib")
$:.push File.dirname(__FILE__)

require 'tool_shed'
require 'bundler'

Bundler.require :development
