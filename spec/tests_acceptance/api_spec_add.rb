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

  VcrHelper.setup_vcr
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

  describe 'Add text route' do
    it 'should be able to add a text' do
      post "api/v1/answer/#{SCRIPT_CODE}"

      _(last_response.status).must_equal 201

      text_entitu = JSON.parse last_response.body
      _(text_entitu['name']).must_equal SCRIPT

      proj = CodePraise::Representer::Project.new(
        CodePraise::Value::OpenStructWithLinks.new
      ).from_json last_response.body
      _(proj.links['self'].href).must_include 'http'
    end
  end

end
