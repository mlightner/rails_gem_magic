# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "rails_gem_magic"
  gem.homepage = "http://github.com/mlightner/rails_gem_magic"
  gem.license = "MIT"
  gem.summary = %Q{A gem which can be installed on a Rails app to allow for easy creation of other Rails-aware gems.}
  gem.description = %Q{Takes the pain out of creating gems that play well with Rails allowing you to easily abstract parts of your application to make available as open source projects or use across your other personal projects.}
  gem.email = "mlightner@gmail.com"
  gem.authors = ["Matt Lightner"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'yard'
YARD::Rake::YardocTask.new
