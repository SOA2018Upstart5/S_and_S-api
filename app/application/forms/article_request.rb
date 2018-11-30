# frozen_string_literal: true

require 'dry-validation'

module SeoAssistant
  module Forms
    ArticleRequest = Dry::Validation.Params do
      # :article should be the same as front_end's input name 
      required(:article).filled

      configure do
        config.messages_file = File.join(__dir__, 'errors/article_request.yml')
      end
    end
  end
end
