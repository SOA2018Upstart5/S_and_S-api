require 'roar/decorator'
require 'roar/json'

module SeoAssistant
	module Representer
		# USAGE:
    #   member = Database::MemberOrm.find(1)
    #   Representer::Member.new(member).to_json
		class Keyword < Roar::decorator
			include Roar::json

			property :word
			property :eng_word
			property :type
			property :importance
			property :url
		end
	end
end