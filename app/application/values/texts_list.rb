# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module SeoAssistant
  module Value
    # List of projects
    TextsList = Struct.new(:texts)
  end
end
