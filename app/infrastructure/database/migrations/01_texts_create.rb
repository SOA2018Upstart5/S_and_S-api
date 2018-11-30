# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:texts) do
      primary_key :id

      String      :text

      index       :text

      DateTime :created_at
      DateTime :updated_at
    end
  end
end
