# frozen_string_literal: true

require 'roda'

module SeoAssistant
  # Web App
  class Api < Roda

    plugin :halt
    plugin :all_verbs
    use Rack::MethodOverride

    route do |routing|
      response['Content-Type'] = 'application/json'

			# check API alive
			# GET /
      routing.root do
        message = "SeoAssistant API v1 at /api/v1/ in #{Api.environment} mode"

        result_response = Representer::HttpResponse.new(
          Value::Result.new(status: :ok, message: message)
        )

        response.status = result_response.http_status_code
        result_response.to_json
      end

      routing.on 'api/v1' do
        routing.on 'answer' do
          routing.on String do |article|
            # POST /answer/{text}
            routing.post do
              result = Service::AddText.new.call(
                text: article
              )

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              Representer::Text.new(result.value!.message).to_json
            end
          end

          routing.is do
            # GET /answer?article=<user input article here>
            routing.get do
              result = Service::ShowText.new.call(
                article_request: Value::ArticleRequest.new(routing.params)
              )

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
              end

              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              Representer::Text.new(result.value!.message).to_json
            end
          end
        end
      end
    end
  end
end
