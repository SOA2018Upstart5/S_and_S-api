require_relative '02_keyword_mapper.rb'
#require_relative '03_url_mapper.rb'

module SeoAssistant
  module OutAPI
    class TextMapper
      def initialize(google_config, unsplash_access_key)
        @google_config = google_config
        @unsplash_key = unsplash_access_key
        @analyze_class = SeoAssistant::OutAPI::Analyze
      end

      def process(text)
        results = @analyze_class.new(@google_config, text).process
        build_entity(text, results)

      end

      def build_entity(text, results)
        DataMapper.new(@google_config, @unsplash_key, text, results).build_entity
      end

      class DataMapper
        def initialize(google_config, unsplash_access_key, text, results)
          @google_config = google_config
          @unsplash_key = unsplash_access_key
          @text = text
          @results = results
        end

        def build_entity
          SeoAssistant::Entity::Text.new(
            id: nil,
            text: @text,
            keywords: keywords,
          )
        end

        def keywords()
          KeywordMapper.new(@google_config, @unsplash_key).load_several(@results)
        end
      end
    end
  end
end
