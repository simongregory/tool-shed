# encoding: utf-8

$:.push File.join(File.dirname(__FILE__), "..", "lib")
$:.push File.dirname(__FILE__)

require 'hel_tools'
require 'bundler'

Bundler.require :development
