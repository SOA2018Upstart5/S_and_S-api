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

desc 'encode the text into uri.code'
task :escape do 
  require 'uri'
  text = "狗是最好的朋友"
  puts URI.escape(text)
end

desc 'encode the text into uri.code'
task :unescape do 
  require 'uri'
  text = "%E7%83%8F%E9%BE%9C%E6%89%8D%E6%98%AF%E4%BA%BA%E9%A1%9E%E7%9A%84%E5%A5%BD%E6%9C%8B%E5%8F%8B"
  puts URI.unescape(text).to_s
end

namespace :db do
  task :config do
    require 'sequel'
    require_relative 'config/environment.rb' # load config info
    def api; SeoAssistant::Api; end
  end

  desc 'Run migrations'
  task :migrate => :config do
    Sequel.extension :migration
    puts "Migrating #{api.environment} database to latest"
    Sequel::Migrator.run(api.DB, 'app/infrastructure/database/migrations')
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

namespace :cache do
  task :config do
    require_relative 'config/environment.rb' # load config info
    require_relative 'app/infrastructure/cache/init.rb' # load cache client
    @api = SeoAssistant::Api
  end

  namespace :list do
    task :dev do
      puts 'Finding development cache'
      list = `ls _cache`
      puts 'No local cache found' if list.empty?
      puts list
    end

    task :production => :config do
      puts 'Finding production cache'
      keys = SeoAssistant::Cache::Client.new(@api.config).keys
      puts 'No keys found' if keys.none?
      keys.each { |key| puts "Key: #{key}" }
    end
  end

  namespace :wipe do
    task :dev do
      puts 'Deleting development cache'
      sh 'rm -rf _cache/*'
    end

    task :production => :config do
      print 'Are you sure you wish to wipe the production cache? (y/n) '
      if STDIN.gets.chomp.downcase == 'y'
        puts 'Deleting production cache'
        wiped = SeoAssistant::Cache::Client.new(@api.config).wipe
        wiped.keys.each { |key| puts "Wiped: #{key}" }
      end
    end
  end
end