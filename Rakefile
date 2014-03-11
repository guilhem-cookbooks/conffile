require 'foodcritic'
require 'foodcritic/rake_task'
require 'rubocop/rake_task'

desc 'Run RuboCop on the lib directory'
Rubocop::RakeTask.new(:rubocop) do |task|
  # don't abort rake on failure
  task.fail_on_error = false
end

desc 'Run Foodcritic lint checks'
FoodCritic::Rake::LintTask.new(:lint) do |t|
  t.options = {
    :fail_tags => ['any'],
    :tags => [
      '~FC003',
      '~FC015'
    ]
  }
end

desc 'Run all tests'
task :test => [:lint, :rubocop]
task :default => :test

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new

  desc 'Alias for kitchen:all'
  task :integration => 'kitchen:all'
  task :test_all => [:test, :integration]
rescue LoadError
  puts '>>>>> Kitchen gem not loaded, omitting tasks' unless ENV['CI']
end
