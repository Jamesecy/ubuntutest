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
  # gem is a Gem::Specification... see http://guides.rubygems.org/specification-reference/ for more options
  gem.name = 'cenit-collection-twilio'
  gem.license = "MIT"
  gem.summary = 'Shared Collection cenit-collection-twilio to be use in Cenit'
  gem.description = 'Shared Collection cenit-collection-twilio to be use in Cenit'
  gem.author = 'Asnioby Hdez'
  gem.email = 'asnioby@gmail.com'
  gem.homepage = 'https://github.com/asnioby/cenit-collection-twilio'
  
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

class Jeweler::Generator
  def target_dir
    '.'
  end
  def create_git_and_github_repo
    create_version_control
    create_and_push_repo
  end
end
      
desc "create a new git and related GitHub's repository'"
task :create_repo do
  options = {
    project_name: 'cenit-collection-twilio', 
    user_name: 'Asnioby Hdez', 
    user_email: 'asnioby@gmail.com',
    github_username: 'asnioby',
    summary: 'Shared Collection cenit-collection-twilio to be use in Cenit',
    description: 'Shared Collection cenit-collection-twilio to be use in Cenit',
    homepage: 'https://github.com/asnioby/cenit-collection-twilio',
    testing_framework: :rspec, 
    documentation_framework: :rdoc
  }
  g = Jeweler::Generator.new(options)
  g.create_git_and_github_repo
end

desc "push shared collection into CENIT-Hub"
require File.expand_path(File.join(*%w[ lib cenit collection twilio]), File.dirname(__FILE__))
task :push do

  push_api = 'http://localhost:3000/api/v1/push'

  puts 'Default value for Push API: http://localhost:3000/api/v1/push'
  api = ask("New PUSH API: ")

  push_api = api unless api.nil? || api.empty?

  user_key = ask("User Key: ")
  user_token = ask("User Token: ")
  config = {:push_url=> push_api, :user_key=> user_key, :user_token=> user_token}

  respose = Cenit::Collection.push_collection(config)
  puts respose
end

desc "show shared collection"
require File.expand_path(File.join(*%w[ lib cenit collection twilio]), File.dirname(__FILE__))
task :show do
  puts Cenit::Collection.show_collection
end

desc "push sample data"
require File.expand_path(File.join(*%w[ lib cenit collection twilio]), File.dirname(__FILE__))
task :push_sample do
  push_api = 'http://localhost:3000/api/v1/push'

  puts 'Default value for Push API: http://localhost:3000/api/v1/push'
  api = ask("New PUSH API: ")

  push_api = api unless api.nil? || api.empty?

  user_key = ask("User Key: ")
  user_token = ask("User Token: ")
  config = {:push_url=> push_api, :user_key=> user_key, :user_token=> user_token}
  model = ask("Model name: ")

  response = Cenit::Collection.push_sample(model, config) unless model.nil? || model.empty?
  puts response
end

desc "import json collection source"
require File.expand_path(File.join(*%w[ lib cenit collection twilio]), File.dirname(__FILE__))
require 'fileutils'
task :import do
  begin
    source= ask("Source path: ")
    data = File.open(source, mode: "r:utf-8").read
    Cenit::Collection.import data unless data.nil? || data.empty?
    puts "Import success"
  rescue (puts "Error import json")
  end
end

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

desc "Code coverage detail"
task :simplecov do
  ENV['COVERAGE'] = "true"
  Rake::Task['spec'].execute
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "cenit-collection-twilio #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
