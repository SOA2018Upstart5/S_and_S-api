#Not finished yet

module SeoAssistant
    module Repository
      # Repository for Project Entities
      class Texts
        def self.all
          Database::TextOrm.all.map { |db_text| rebuild_entity(db_text) }
        end

        def self.find_text(text)
          db_text = Database::TextOrm.first(text: text)
          rebuild_entity(db_text)
        end

        def self.find_texts(texts)
          texts.map do |text|
            find_text(text)
          end
        end

        def self.find_id(id)
          db_record = Database::TextOrm.first(id: id)
          rebuild_entity(db_record)
        end

        def self.create(entity)
          #raise 'Text already exists' if find(entity)
          db_text = PersistText.new(entity).call
          rebuild_entity(db_text)
        end

        private

        def self.rebuild_entity(db_record)
          return nil unless db_record

          Entity::Text.new(
            db_record.to_hash.merge(
              text: db_record.text,
              keywords: Keywords.rebuild_many(db_record.keywords)
            )
          )
        end

        # Helper class to persist project and its members to database
        class PersistText
          def initialize(entity)
            @entity = entity
          end

          def create_text
            Database::TextOrm.create(@entity.to_attr_hash)
          end

          def call
            create_text.tap do |db_text|
              @entity.keywords.each do |keyword|
                db_text.add_keyword(Keywords.db_find_or_create(keyword))
              end
            end
          end
        end
      end
    end
  end
