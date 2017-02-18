require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rspec'
require 'serverspec'

task default: :spec

RSpec::Core::RakeTask.new(:spec) do |task|
  task.rspec_opts = ['--color']
end