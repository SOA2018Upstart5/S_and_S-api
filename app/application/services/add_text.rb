# frozen_string_literal: true
#not finished

require 'dry/transaction'

module SeoAssistant
  module Service
    # Transaction to store project from Github API to database
    class AddText
      include Dry::Transaction

      step :validate_input
      step :find_text
      step :store_text

      private

      def validate_input(input)
        if input.success?
          article = input[:article].to_s
          Success(text: article)
        else
          Failure(input.errors.values.join('; '))
        end
      end

      def find_text(input)
        if (text = text_in_database(input))
          input[:local_text] = text
        else
          input[:remote_text] = text_from_api(input)
        end
        Success(input)
      rescue StandardError => error
        Failure(error.to_s)
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
        Failure('Having trouble accessing the database')
      end

      # following are support methods that other services could use

      def text_from_api(input)
        #Github::ProjectMapper.new(App.config.GITHUB_TOKEN).find(input[:owner_name], input[:project_name])
        OutAPI::TextMapper
                  .new(JSON.parse(App.config.GOOGLE_CREDS), App.config.UNSPLASH_ACCESS_KEY)
                  .process(input[:text])
      rescue StandardError
        raise 'Could not do analysis'
      end

      def text_in_database(input)
        #Repository::For.klass(Entity::Project).find_full_name(input[:owner_name], input[:project_name])
        Repository::For.klass(Entity::Text).find_text(input[:text])
      end
    end
  end
end
