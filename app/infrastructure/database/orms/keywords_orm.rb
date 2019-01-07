# frozen_string_literal: true

require 'sequel'

module SeoAssistant
  module Database
    # Object Relational Mapper for Project Entities
    class KeywordOrm < Sequel::Model(:keywords)
      many_to_one :text,
                  class: :'SeoAssistant::Database::TextOrm',
                  key: :text_id

      plugin :timestamps, update_on_create: true


      def self.find_or_create(keyword_info)
        first(word: keyword_info[:word]) || create(keyword_info)
      end
    end
  end
end
