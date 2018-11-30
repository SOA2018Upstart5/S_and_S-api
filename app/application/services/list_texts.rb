# frozen_string_literal: true

require 'dry/monads'

module SeoAssistant
  module Service
    # Retrieves array of all listed project entities
    class ListTexts
      include Dry::Monads::Result::Mixin

      def call(texts_list)
        texts = Repository::For.klass(Entity::Text).find_texts(texts_list)
        Success(texts)
      rescue StandardError
        Failure('Could not access database')
      end
    end
  end
end