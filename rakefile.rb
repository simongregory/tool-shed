require 'bundler'

Bundler.require

require 'metric_fu'
require 'rake/clean'
require 'rake/testtask'
require 'rake/rdoctask'

ENV['CI_REPORTS'] = 'tmp/reports' #Hide these here for now...
require 'ci/reporter/rake/test_unit'

require File.dirname(__FILE__) + '/lib/shed/version'

MetricFu::Configuration.run do |config|
  config.rcov[:test_files] = ['test/unit/**/test_*.rb']
  config.flay ={:dirs_to_flay => ['lib'],
                :minimum_score => 10,
                :filetypes => ['rb'] }
end

CLEAN.add('tmp')

Rake::RDocTask.new do |rdoc|
  rdoc.title = " ActionScript Tools v.#{ToolShed::VERSION::STRING}"
  rdoc.rdoc_dir = 'rdoc'
  rdoc.main = "ToolShed::ToolShed"
  rdoc.rdoc_files.include("README.md", "LICENSE", "lib/**/*.rb")
end

Rake::TestTask.new(:test) do |test|
  test.libs << "test"
  test.test_files = Dir["test/unit/test_*.rb"]
  test.verbose = true
end

CLEAN.add('rdoc')

desc "Default"
task :default => [:test]

desc "Run all tests and reports"
task :hudson => ['ci:setup:testunit', :test, 'metrics:all']

#############################################################################
#
# Packaging tasks
#
#############################################################################

task :release do
  puts ""
  print "Are you sure you want to relase tool-shed #{ToolShed::VERSION::STRING}? [y/N] "
  exit unless STDIN.gets.index(/y/i) == 0
  
  unless `git branch` =~ /^\* master$/
    puts "You must be on the master branch to release!"
    exit!
  end
  
  # Build gem and upload
  sh "gem build tool-shed.gemspec"
  sh "gem push tool-shed-#{ToolShed::VERSION::STRING}.gem"
  sh "rm tool-shed-#{ToolShed::VERSION::STRING}.gem"
  
  # Commit
  sh "git commit --allow-empty -a -m 'v#{ToolShed::VERSION::STRING}'"
  sh "git tag v#{ToolShed::VERSION::STRING}"
  sh "git push origin master"
  sh "git push origin v#{ToolShed::VERSION::STRING}"
end
