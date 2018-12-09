# frozen_string_literal: false

source 'https://rubygems.org'
ruby '2.5.1'

# Representers Layer
gem 'multi_json'
gem 'roar'

# Web application related
gem 'puma', '~> 3.11'
gem 'roda', '~> 3.8'
gem 'econfig', '~> 2.1'
gem 'rack-cache', '~> 1.8'
gem 'redis', '~> 4.0'
gem 'redis-rack-cache', '~> 2.0'
gem 'roda', '~> 3.8'

# Controllers and services
gem 'dry-monads'
gem 'dry-transaction'
gem 'dry-validation'

# Domain Layer
gem 'dry-struct', '~> 0.5'
gem 'dry-types', '~> 0.5'

#  Networking
gem'http',  '~>  3.0'

# Database related
gem 'hirb'
gem 'sequel'

group :development, :test do
  gem 'database_cleaner'
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end

# DEBUGGING
group :development, :test do
  gem 'pry-rescue'
  gem 'pry-stack_explorer'
end

# TESTING
group :test do
  gem 'minitest', '~> 5.11'
  gem 'minitest-rg', '~> 5.2'
  gem 'simplecov', '~> 0.16'
  gem 'vcr', '~> 4.0'
  gem 'webmock', '~> 3.4'
end

# can also be used to diagnose production
gem 'rack-test'

# Quality
group :development, :test do
  gem 'flog'
  gem 'reek'
  gem 'rubocop'
end

# UTILITIES
gem 'pry'
gem 'rake', '~> 12.3'
gem 'travis'

group :development, :test do
  gem 'rerun', '~> 0.13'
end


#########Other############

# Google Cloud API
gem'google-cloud-language'
gem'google-cloud-translate'

# Upsplash
gem 'unsplash'
