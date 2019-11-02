# frozen_string_literal: true

module Support
  module JsonHelpers
    def json_data
      @json_data ||= JSON.parse(response.body, symbolize_names: true)
    end
  end
end
