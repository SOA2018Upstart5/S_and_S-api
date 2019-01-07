# frozen_string_literal: false

require 'google/cloud/translate'

module SeoAssistant
  module OutAPI
    class Translate
      def initialize(google_config, chinese_str)
        @google_cred = google_config
        @project_id = 'My Project'
        @text = chinese_str
        @target = 'eng'
      end

      def process
        translate = Google::Cloud::Translate.new(
          project_id: @project_id,
          credentials: @google_cred
        )
        translation = translate.translate @text, to: @target
        translation.to_s
      end
    end
  end
end
