# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"

RuboCop::RakeTask.new

namespace :coverage do
  task :report do
    require "simplecov"
    SimpleCov.start do
      add_filter "/spec/"
      add_filter "/vendor/"
    end
    Rake::Task["spec"].execute
  end
end

task coverage: ["coverage:report"]

task default: %i[spec rubocop]
