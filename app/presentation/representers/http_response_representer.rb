require 'roar/decorator'
require 'roar/json'

module SeoAssistant
  module Representer
		#  Representerfor  HTTP  response  information
		class HttpResponse < Roar::Decorator
			include Roar::JSON
			
			property  :status
			property  :message
			
			HTTP_CODE={
				ok:200,
				created:201,
				processing:202,
				no_content:204,
				forbidden:403,
				not_found:404,
				bad_request:400,
				conflict:409,
				cannot_process:422,
				internal_error:500
			}.freeze
			
			def http_status_code
				HTTP_CODE[represented.status]
			end
		end
	end
end