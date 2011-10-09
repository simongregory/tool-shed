# encoding: utf-8

begin
  Rake

  require 'rake/tasklib'

  require 'shed/rake/version'
  require 'shed/rake/headers'
  require 'shed/rake/manifest'
rescue
 # Only require the rake tasks where rake is already present on the load path
 # Otherwise keep quiet...
end
