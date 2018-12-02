# frozen_string_literal: true

require 'roda'
require 'uri'
require 'json'
#decode
#article_encoded = article.encode('UTF-8', invalid: :replace, undef: :replace)
#article_unescaped = URI.unescape(article_encoded).to_s

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
        #message = "SeoAssistant API v1 at /api/v1/ in #{Api.environment} mode"
        message = "SeoAssistant API v1 at /api/v1/"

        result_response = Representer::HttpResponse.new(
          Value::Result.new(status: :ok, message: message)
        )

        response.status = result_response.http_status_code
        result_response.to_json
      end

      routing.on 'api/v1' do
        routing.on 'answer' do
          routing.on String do |article|
            # Show
            # GET /api/v1/answer/{text}
            routing.get do
              #decode
              result = Service::ShowText.new.call(article: article)

              if result.failure?
                failed = Representer::HttpResponse.new(result.failure)
                routing.halt failed.http_status_code, failed.to_json
                puts "api: show text failed"
              end
              puts "api: show text success"
              http_response = Representer::HttpResponse.new(result.value!)
              response.status = http_response.http_status_code
              puts "api: result.value!"
              puts result.value!
              Representer::Text.new(result.value!.message).to_json
            end
            # Add
            # POST /api/v1/answer/{text}
            routing.post do
              #decode
              article_encoded = article.encode('UTF-8', invalid: :replace, undef: :replace)
              article_unescaped = URI.unescape(article_encoded).to_s
              puts article_unescaped
              result = Service::AddText.new.call(text: article_unescaped)

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
            # List
            # GET /api/v1/answer?article=<user input article here>
            routing.get do
              result = Service::ListTexts.new.call(
                article_request: Value::ArticlesRequest.new(routing.params)
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
