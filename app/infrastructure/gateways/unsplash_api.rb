# frozen_string_literal: false

require 'http'

module SeoAssistant
  module OutAPI
    # Library of Unsplash API
    class Unsplash
      def initialize(unsplash_access_key, keyword_str)
        @access_key = unsplash_access_key
        @query = keyword_str
      end

      def get(url)
        HTTP.headers(
          'Authorization' => 'Client-ID ' + @access_key
        ).get(url)
      end

      def process
        path = 'https://api.unsplash.com/' + '/search/photos?query=' + @query
        pictures_data = get(path).parse
      end
    end
  end
end
