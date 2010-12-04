# encoding: utf-8

lib = File.expand_path File.join(File.dirname(__FILE__), 'lib')
$:.unshift lib unless $:.include?(lib)

require 'bundler'
require 'rake'
require 'tool_shed'

#
# For gem spec reference see:
# http://docs.rubygems.org/read/chapter/20#rubyforge_project
#
Gem::Specification.new do |s|
  s.name                      = ToolShed::NAME
  s.version                   = ToolShed::VERSION::STRING
  s.platform                  = Gem::Platform::RUBY
  s.authors                   = ["Simon Gregory"]
  s.email                     = "tool-shed@helvector.org"
  s.homepage                  = "http://github.com/simongregory/tool-shed"
  s.summary                   = "ActionScript and Flex Project Tools"
  s.description               = <<EOF
Utility scripts for working with ActionScript and Flex projects.
EOF
  s.has_rdoc                  = true
  s.rdoc_options              = ["--charset=UTF-8"]
  s.extra_rdoc_files          = ['LICENSE', 'README.md']
  s.required_rubygems_version = ">= 1.3.6"
  s.require_path              = ['lib']
  s.files                     = FileList['**/**/*'].exclude /.git|.svn|.DS_Store|.tmproj|tmp|.gem/
  s.test_files                = Dir["test/*_test.rb"]
  s.executables               = ['as-docp', 'as-manifest', 'as-class-vacuum',
                                 'as-style-vacuum', 'as-asset-vacuum', 'as-concrete']
  s.post_install_message      = <<EOF
Welcome to the Tool-Shed
========================
Get Tooled Up #{ToolShed::VERSION::STRING}. Kick off.

Thanks for installing, the tools are under development. Don't expect reliability.

EOF
  s.add_bundler_dependencies

end
