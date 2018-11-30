# frozen_string_literal: true

require_relative 'view_text'

module Views
    # View for a a list of project entities
    class TextsList
      def initialize(texts)
        @texts = texts.map.with_index { |tx, i| Text.new(tx, i) }
      end
  
      def each
        @texts.each do |tx|
          yield tx
        end
      end
  
      def any?
        @texts.any?
      end
    end
  end