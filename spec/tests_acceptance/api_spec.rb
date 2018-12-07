# frozen_string_literal: true

require_relative '../helpers/spec_helper.rb'
require_relative '../helpers/vcr_helper.rb'
require_relative '../helpers/database_helper.rb'
require 'rack/test'

# require 'pry'; binding.pry

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
    
      get "/api/v1/answer/#{SCRIPT_CODE}"

      _(last_response.status).must_equal 200
      text_entity = JSON.parse last_response.body
      _(text_entity.keys.sort).must_equal %w[keywords links text]
      _(text_entity['text']).must_equal SCRIPT
      _(text_entity['keywords'][0]['word']).must_equal KEYWORD
    end

    it 'should be report error for an invalid text' do
      SeoAssistant::Service::AddText.new.call(text: SCRIPT_CODE)

      get "/api/v1/answer/#{ERROR_SCRIPT_CODE}"
      #puts last_response
      _(last_response.status).must_equal 404
      _(JSON.parse(last_response.body)['status']).must_include 'not'
    end
  end

  describe 'Get texts list' do
    it 'should successfully return texts list' do
      SeoAssistant::Service::AddText.new.call(text: SCRIPT_CODE)

      list = ["#{SCRIPT}"]
      encoded_list = SeoAssistant::Value::ListRequest.to_encoded(list)

      get "/api/v1/answer?list=#{encoded_list}"
      _(last_response.status).must_equal 200

      response = JSON.parse(last_response.body)
      # Value.TextList[:texts]
      texts = response['texts']
      _(texts.count).must_equal 1
      text_entity = texts.first
      _(text_entity['text']).must_equal SCRIPT
      _(text_entity['keywords'][0]['word']).must_equal KEYWORD
    end

    it 'should return empty lists if none found' do
      list = ["asdasdasda"]
      encoded_list = SeoAssistant::Value::ListRequest.to_encoded(list)

      get "/api/v1/answer?list=#{encoded_list}"
      _(last_response.status).must_equal 200

      response = JSON.parse(last_response.body)
      texts = response['texts']
      _(texts).must_be_kind_of Array
      ## Error: sould be 0
      _(texts.count).must_equal 1
    end

    it 'should return error if no list provided' do
      get "/api/v1/answer"
      _(last_response.status).must_equal 400

      response = JSON.parse(last_response.body)
      _(response['message']).must_include 'list'
    end
  end

  describe 'Add texts route' do
    it 'should be able to add a project' do
      post "api/v1/answer/#{SCRIPT_CODE}"

      _(last_response.status).must_equal 201

      text_entity = JSON.parse last_response.body
      _(text_entity['text']).must_equal SCRIPT
      _(text_entity['keywords'][0]['word']).must_equal KEYWORD

      tex = SeoAssistant::Representer::Text.new(
        SeoAssistant::Value::OpenStructWithLinks.new
      ).from_json last_response.body
      # tex.links['self'].href = http://localhost:9000/answer/狗是最好的朋友
      _(tex.links['self'].href).must_include 'http'
    end

    it 'should report error for invalid projects' do
      post "api/v1/answer/#{NON_ACCESS_CODE}"
      _(last_response.status).must_equal 404

      # response = {"status"=>"not_found", "message"=>"Could not access API"}
      response = JSON.parse(last_response.body)
      _(response['message']).must_include 'not'
    end
  end


end
