# frozen_string_literal: false

require 'rake/testtask'

task :default do
  puts `rake -T`
end

desc 'Run tests once'
Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
  t.warning = false
end

desc 'Run acceptance tests'
# NOTE: run `rake run:test` in another process
Rake::TestTask.new(:spec_accept) do |t|
  t.pattern = 'spec/tests_acceptance/*_spec.rb'
  t.warning = false
end

desc 'Keep rerunning tests upon changes'
task :respec do
  sh "rerun -c 'rake spec' --ignore 'coverage/*'"
end

desc 'Keep restarting web app upon changes'
task :rerack do
  sh "rerun -c rackup --ignore 'coverage/*'"
end

desc 'Format google credentials for injection into secrets.yml'
task :google_creds do
  puts File.read('config/google_credential.json').split("\n").join(' ')
end


namespace :db do
  task :config do
    require 'sequel'
    require_relative 'config/environment.rb' # load config info
    def app; SeoAssistant::App; end
  end

  desc 'Run migrations'
  task :migrate => :config do
    Sequel.extension :migration
    puts "Migrating #{app.environment} database to latest"
    Sequel::Migrator.run(app.DB, 'app/infrastructure/database/migrations')
  end

  desc 'Wipe records from all tables'
  task :wipe => :config do
    require_relative 'spec/helpers/database_helper.rb'
    DatabaseHelper.setup_database_cleaner
    DatabaseHelper.wipe_database
  end

  desc 'Delete dev or test database file'
  task :drop => :config do
    if app.environment == :production
      puts 'Cannot remove production database!'
      return
    end

    FileUtils.rm(SeoAssistant::App.config.DB_FILENAME)
    puts "Deleted #{SeoAssistant::App.config.DB_FILENAME}"
  end
end

desc 'Run application console (pry)'
task :console do
  sh 'pry -r ./init.rb'
end


namespace :vcr do
  desc 'delete cassette fixtures'
  task :wipe do
    sh 'rm spec/fixtures/cassettes/*.yml' do |ok, _|
      puts(ok ? 'Cassettes deleted' : 'No cassettes found')
    end
  end
end

namespace :quality do
  desc 'run all quality checks'
  task all: %i[rubocop reek flog]

  task :flog do
    sh 'flog lib/'
  end

  task :reek do
    sh 'reek lib/'
  end

  task :rubocop do
    sh 'rubocop'
  end
end
