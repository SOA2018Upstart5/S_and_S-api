# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'text_representer'

module SeoAssistant
  module Representer
    # Represents list of projects for API output
    class TextsList < Roar::Decorator
      include Roar::JSON

      collection :texts, extend: Representer::Text, class: Value::OpenStructWithLinks
    end
  end
end
