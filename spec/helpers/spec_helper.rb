# frozen_string_literal: false

ENV['RACK_ENV'] = 'test'

require 'simplecov'
SimpleCov.start

require 'yaml'

require 'minitest/autorun'
require 'minitest/rg'

require 'pry' # for debugging

require_relative '../../init.rb'

SCRIPT_CODE = '%E7%8B%97%E6%98%AF%E6%9C%80%E5%A5%BD%E7%9A%84%E6%9C%8B%E5%8F%8B'.freeze
SCRIPT = '狗是我們的好朋友'.freeze

ERROR_SCRIPT_CODE = '%E8%B2%93%E6%98%AF%E6%9C%80%E5%A5%BD%E7%9A%84%E6%9C%8B%E5%8F%8B'.freeze
ERROR_SCRIPT = '貓是我們的好朋友'.freeze

KEYWORD = 'dog'

UNSPLASH_ACCESS_KEY = SeoAssistant::App.config.UNSPLASH_ACCESS_KEY
GOOGLE_CREDS = JSON.parse(SeoAssistant::App.config.GOOGLE_CREDS)
#CORRECT = YAML.safe_load(File.read('spec/fixtures/api_result.yml'))

# Helper methods
def homepage
  SeoAssistant::App.config.APP_HOST
end