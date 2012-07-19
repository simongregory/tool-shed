# encoding: utf-8

lib = File.expand_path File.join(File.dirname(__FILE__), 'lib')
$:.unshift lib unless $:.include?(lib)

require 'bundler'
require 'shed/version'

Gem::Specification.new do |s|
  s.name                      = ToolShed::NAME
  s.version                   = ToolShed::VERSION::STRING
  s.platform                  = Gem::Platform::RUBY
  s.authors                   = ["Simon Gregory"]
  s.email                     = "tool-shed@helvector.org"
  s.homepage                  = "http://github.com/simongregory/tool-shed"
  s.summary                   = "ActionScript and Flex Project Tools"
  s.description               = 'Utility scripts and Rake tasks for working with ActionScript and Flex projects.'
  s.has_rdoc                  = true
  s.rdoc_options              = ["--charset=UTF-8"]
  s.extra_rdoc_files          = ['LICENSE', 'README.md']
  s.required_rubygems_version = ">= 1.3.6"
  s.files                      = Dir['**/*']
  s.files.reject!              { |fn| fn.match /\.(DS_Store|svn|git|tmproj|gem)|tmp/ }
  s.test_files                 = Dir["test/*_test.rb"]
  s.executables                = ['as-docp', 'as-manifest', 'as-class-vacuum',
                                 'as-style-vacuum', 'as-asset-vacuum', 'as-concrete']
  s.post_install_message       = <<EOF
Welcome to the Tool-Shed
========================
Get Tooled Up #{ToolShed::VERSION::STRING}. Kick off.

Thanks for installing:

  as-asset-vacuum
  as-class-vacuum
  as-concrete
  as-docp
  as-manifest
  as-style-vacuum
  as-vacuum

The tools are under development so may be a little
tempremental. When they 'just work' it's likely
they're running from a project root, which contains
src, test and lib dirs.

See the README for more details, each tool can be run
with -h for a list of options.

EOF
  s.add_dependency 'rake', '>= 0.9.2'
  s.add_development_dependency 'shoulda'
  s.add_development_dependency 'mocha'
  s.require_paths << 'lib'
end
