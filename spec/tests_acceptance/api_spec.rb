# frozen_string_literal: true

require_relative '../helpers/spec_helper.rb'
require_relative '../helpers/vcr_helper.rb'
require_relative '../helpers/database_helper.rb'
require 'rack/test'

def app
  SeoAssistant::Api
end

describe 'Test API routes' do
  include Rack::Test::Methods

  #VcrHelper.setup_vcr
  DatabaseHelper.setup_database_cleaner

  before do
    # VcrHelper.configure_vcr_for_nl
    DatabaseHelper.wipe_database
  end

  after do
    # VcrHelper.eject_vcr
  end

  describe 'Root route' do
    it 'should successfully return root information' do
      get '/'
      _(last_response.status).must_equal 200
      body = JSON.parse(last_response.body)
      _(body['status']).must_equal 'ok'
      _(body['message']).must_include 'api/v1'
    end
  end

  describe 'Show route' do
    it 'should be able to show the information of text' do
      SeoAssistant::Service::AddText.new.call(text: SCRIPT_CODE)
      # require 'pry'
      # binding.pry
      get "/api/v1/answer/#{SCRIPT_CODE}"
      #puts "show route:" + last_response.status
      _(last_response.status).must_equal 200
      #appraisal = JSON.parse last_response.body
      #_(appraisal.keys.sort).must_equal %w[folder project]
      #_(appraisal['text']).must_equal SCRIPT
    end

    it 'should be report error for an invalid text' do
      SeoAssistant::Service::AddText.new.call(text: SCRIPT)

      get "/api/v1/answer/#{ERROR_SCRIPT_CODE}"
      #puts last_response
      _(last_response.status).must_equal 404
      #_(JSON.parse(last_response.body)['status']).must_include 'not'
    end
  end

end
