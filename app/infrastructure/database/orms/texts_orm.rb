# frozen_string_literal: true

require 'sequel'

module SeoAssistant
  module Database
    # Object-Relational Mapper for Members
    class TextOrm < Sequel::Model(:texts)
      one_to_many :keywords,
                  class: :'SeoAssistant::Database::KeywordOrm',
                  key: :text_id

      plugin :timestamps, update_on_create: true


    end
  end
end
