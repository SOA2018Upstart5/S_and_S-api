# frozen_string_literal: true
#not finished

require 'dry/transaction'

module SeoAssistant
  module Service
    # Transaction to store project from Github API to database
    class AddText
      include Dry::Transaction

      step :find_text
      step :store_text

      private

      DB_ERR_MSG = 'Having trobule accessing the database'
      API_NOT_FOUND_MSG = 'Could not do analysis'

      def find_text(input)
        if (text = text_in_database(input))
          input[:local_text] = text
        else
          input[:remote_text] = text_from_api(input)
        end
        Success(input)
      rescue StandardError => error
        Failure(Value::Result.new(status: :not_found, message: :error.to_s))
      end

      def store_text(input)
        text =
          if (new_text = input[:remote_text])
            Repository::For.entity(new_text).create(new_text)
          else
            input[:local_text]
          end
        Success(text)
      rescue StandardError => error
        puts error.backtrace.join("\n")
        Failure(Value::Result.new(status: :internal_error, message: DB_ERR_MSG))
      end

      # following are support methods that other services could use

      def text_from_api(input)
        #Github::ProjectMapper.new(App.config.GITHUB_TOKEN).find(input[:owner_name], input[:project_name])
        OutAPI::TextMapper
                  .new(JSON.parse(App.config.GOOGLE_CREDS), App.config.UNSPLASH_ACCESS_KEY)
                  .process(input[:text])
      rescue StandardError
        raise API_NOT_FOUND_MSG
      end

      def text_in_database(input)
        #Repository::For.klass(Entity::Project).find_full_name(input[:owner_name], input[:project_name])
        Repository::For.klass(Entity::Text).find_text(input[:text])
      end
    end
  end
end
