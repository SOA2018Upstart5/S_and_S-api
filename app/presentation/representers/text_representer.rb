require 'roar/decorator'
require 'roar/json'

require_relative 'keyword_representer.rb'

module SeoAssistant
	module Representer
	
		class Text < Roar::Decorator
			include Roar::JSON
			include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

			property :text
			collection :keywords, extend: Representer::Keyword, class: OpenStruct
		

			link :self do
				"#{Api.config.API_HOST}/answer/#{text}"
			end

			private

			def text
				represented.text
			end
		end
	end
end