# frozen_string_literal: false

require 'google/cloud/language'

module SeoAssistant
  module OutAPI
    #Library for Google Cloud Natural Language API
    class Analyze
      def initialize(google_config, text_str)
        @google_cred = google_config
        @text_content = text_str
      end

      def process
        language = Google::Cloud::Language.new(
          credentials: @google_cred
        )
        response = language.analyze_entities content: @text_content, type: :PLAIN_TEXT
        entities = response.entities
      end
    end
  end
end

