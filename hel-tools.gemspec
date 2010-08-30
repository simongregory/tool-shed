# encoding: utf-8

lib = File.expand_path File.join(File.dirname(__FILE__), 'lib')
$:.unshift lib unless $:.include?(lib)

require 'bundler'
require 'rake'
require 'hel_tools'

#
# For gem spec reference see:
# http://docs.rubygems.org/read/chapter/20#rubyforge_project
#
Gem::Specification.new do |s|
  s.name                      = HelTool::NAME
  s.version                   = HelTool::VERSION::STRING
  s.platform                  = Gem::Platform::RUBY
  s.authors                   = ["Simon Gregory"]
  s.email                     = "tools@helvector.org"
  s.homepage                  = "http://github.com/simongregory/hel-tools"
  s.summary                   = "Helvector ActionScript Tools"
  s.description               = <<EOF
Utility scripts for working with ActionScript projects
EOF
  s.has_rdoc                  = true
  s.rdoc_options              = ["--charset=UTF-8"]
  s.extra_rdoc_files          = ['LICENSE', 'README.md']
  s.required_rubygems_version = ">= 1.3.6"
  s.require_path              = ['lib']
  s.files                     = FileList['**/**/*'].exclude /.git|.svn|.DS_Store|.tmproj/
  s.test_files                = Dir["test/*_test.rb"]
  s.executables               = ['as-docp', 'as-manifest', 'as-class-detector', 'as-style-detector']
  s.post_install_message      = <<EOF
Say Hello to Hel-Tools
======================
Get Tooled Up #{HelTool::VERSION::STRING}. Don't think. Kick off.

EOF
  s.add_bundler_dependencies

end
