# frozen_string_literal: true

require_relative 'spec_helper.rb'
require_relative 'helpers/vcr_helper.rb'

describe 'Tests NL API library' do
  before do
    VcrHelper.setup_vcr
    VcrHelper.configure_vcr_for_nl
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'Analyze information' do
    it 'HAPPY: should provide correct keyword information' do
      analyze = SeoAssistant::OutAPI::Analyze.new(GOOGLE_CREDS, SCRIPT).process
      _(analyze.keyword).must_equal CORRECT['Analze']['keyword']
      _(analyze.type).must_equal CORRECT['Analze']['type']
      _(analyze.importance).must_equal CORRECT['Analze']['importance']
    end

    it 'BAD: should raise exception when unauthorized' do
      proc do
        SeoAssistant::OutAPI::Analyze.new('BAD_CREDS', SCRIPT).process
      end.must_raise SeoAssistant::OutAPI::Api::Response::Unauthorized
    end
  end
end


describe 'Tests Translate API library' do
  before do
    VcrHelper.setup_vcr
    VcrHelper.configure_vcr_for_translate
  end

  after do
    VcrHelper.eject_vcr
  end

  describe 'translate result' do
    it 'HAPPY: should provide correct keyword information' do
      translate = SeoAssistant::OutAPI::Translate.new(GOOGLE_CREDS, SCRIPT).process
      _(translate).must_equal CORRECT['Translate']

    end

    it 'BAD: should raise exception when unauthorized' do
      proc do
        SeoAssistant::OutAPI::Translate.new('BAD_CREDS', SCRIPT).process
      end.must_raise SeoAssistant::App::OutAPI::Api::Response::Unauthorized
    end
  end
end


describe 'Tests Unsplash API library' do
  before do
    VcrHelper.setup_vcr
    VcrHelper.configure_vcr_for_unsplash
  end

  after do
    VcrHelper.eject_vcr
  end
  describe 'Picture information' do
    it 'HAPPY : should provide correct link' do
      picture = SeoAssistant::OutAPI::Unsplash.new(ACCESS_KEY, KEYWORD).process
      _(picture.first_url).must_equal CORRECT['Picture']
    end

    it 'BAD: should raise exception when unauthorized' do
      proc do
        SeoAssistant::Unsplash.new('BAD_ACCESS_KEY', KEYWORD).process
      end.must_raise SeoAssistant::OutAPI::Api::Response::Unauthorized
    end
  end
end