# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:keywords) do
      primary_key :id
      foreign_key :text_id, :texts

      String      :word
      String      :eng_word
      String      :type
      Float       :importance
      String      :url

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
