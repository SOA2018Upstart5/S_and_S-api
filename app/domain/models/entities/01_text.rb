require_relative '02_keyword.rb'

module SeoAssistant
  module Entity
    class Text < Dry::Struct
      include Dry::Types.module

      attribute :id,  Integer.optional
      attribute :text, Strict::String
      attribute :keywords, Strict::Array.of(Keyword)

      #reject variabel which would  merge with other.
      def to_attr_hash
        to_hash.reject { |key, _| [:id, :keywords].include? key }
      end
    end
  end
end
