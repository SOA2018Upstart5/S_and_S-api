# frozen_string_literal: true

require 'vcr'
require 'webmock'

# Setting up VCR
class VcrHelper
  CASSETTES_FOLDER = 'spec/fixtures/cassettes'.freeze
  UNSPLASH_CASSETTE = 'unsplash_api'.freeze
  TRANSLATE_CASSETTE = 'translate_api'.freeze
  NL_CASSETTE = 'nl_api'.freeze

  def self.setup_vcr
    VCR.configure do |c|
      c.cassette_library_dir = CASSETTES_FOLDER
      c.hook_into :webmock
    end
  end

  def self.configure_vcr_for_nl
    VCR.configure do |c|
      c.filter_sensitive_data('<GOOGLE_CREDS>') { GOOGLE_CREDS }
      c.filter_sensitive_data('<GOOGLE_CREDS>') { CGI.escape(GOOGLE_CREDS) }
    end

    VCR.insert_cassette(
      NL_CASSETTE,
      record: :new_episodes,
      match_requests_on: %i[method uri headers]
    )
  end

  def self.configure_vcr_for_translate
    VCR.configure do |c|
      c.filter_sensitive_data('<GOOGLE_CREDS>') { GOOGLE_CREDS }
      c.filter_sensitive_data('<GOOGLE_CREDS>') { CGI.escape(GOOGLE_CREDS) }
    end

    VCR.insert_cassette(
      TRANSLATE_CASSETTE,
      record: :new_episodes,
      match_requests_on: %i[method uri headers]
    )
  end

  def self.configure_vcr_for_unsplash
    VCR.configure do |c|
      c.filter_sensitive_data('<UNSPLASH_ACCESS_KEY>') { UNSPLASH_ACCESS_KEY }
      c.filter_sensitive_data('<UNSPLASH_ACCESS_KEY_ESC>') { CGI.escape(UNSPLASH_ACCESS_KEY) }
      c.filter_sensitive_data('<UNSPLASH_SECRET_KEY>') { UNSPLASH_SECRET_KEY }
      c.filter_sensitive_data('<UNSPLASH_SECRET_KEY>') { CGI.escape(UNSPLASH_SECRET_KEY) }
    end

    VCR.insert_cassette(
      UNSPLASH_CASSETTE,
      record: :new_episodes,
      match_requests_on: %i[method uri headers]
    )
  end

  def self.eject_vcr
    VCR.eject_cassette
  end
end
