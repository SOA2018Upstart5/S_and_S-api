# frozen_string_literal: true
#Not finished yet

module SeoAssistant
  module Repository
    # Repository for Keywords
    class Keywords
      def self.find_id(id)
        db_record = Database::KeywordOrm.first(id: id)
        rebuild_entity(db_record)
      end

      private

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Keyword.new(
          id:           db_record.id,
          word:         db_record.word,
          eng_word:     db_record.eng_word,
          type:         db_record.type,
          importance:   db_record.importance,
          url:          db_record.url
        )
      end

      def self.rebuild_many(db_keywords)
        db_keywords.map do |db_keyword|
          Keywords.rebuild_entity(db_keyword)
        end
      end

      def self.db_find_or_create(keyword_entity)
        Database::KeywordOrm.find_or_create(keyword_entity.to_attr_hash)
      end
    end
  end
end
