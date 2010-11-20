
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
task :cruise => ['ci:setup:testunit', 'metrics:all']
