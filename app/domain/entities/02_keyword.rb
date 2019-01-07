module SeoAssistant
  module Entity
    class Keyword < Dry::Struct
      include Dry::Types.module

      attribute :id,  Integer.optional
      attribute :word, Strict::String
      attribute :eng_word, Strict::String
      attribute :type, Strict::String
      attribute :importance, Strict::Float
      attribute :url, Strict::String

      def to_attr_hash
        to_hash.reject { |key, _| [:id].include? key }
      end
    end
  end
end