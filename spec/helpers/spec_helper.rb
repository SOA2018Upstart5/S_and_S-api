# frozen_string_literal: false

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'

require 'pry' # for debugging

require_relative '../init.rb'

SCRIPT = '狗是我們的好朋友'.freeze
KEYWORD = 'dog'

UNSPLASH_ACCESS_KEY = SeoAssistant::App.config.UNSPLASH_ACCESS_KEY
GOOGLE_CREDS = JSON.parse(SeoAssistant::App.config.GOOGLE_CREDS)
CORRECT = YAML.safe_load(File.read('spec/fixtures/api_result.yml'))

# Helper methods
def homepage
  SeoAssistant::App.config.APP_HOST
end