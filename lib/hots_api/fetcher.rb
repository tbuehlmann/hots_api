# frozen_string_literal: true

require 'http'

module HotsApi
  class Fetcher
    ApiLimitReachedError = Class.new(StandardError)

    attr_reader :last_response

    def get(path, params: {})
      with_retrying do
        HTTP.get("http://hotsapi.net/api/v1/#{path}", params: params)
      end
    end

    def post(path, body: nil, file: nil)
      with_retrying do
        HTTP.post("http://hotsapi.net/api/v1/#{path}", post_options_for(body: body, file: file))
      end
    end

    private

    def post_options_for(body:, file:)
      {}.tap do |options|
        options[:body] = body if body
        options[:form] = {file: HTTP::FormData::File.new(file)} if file
      end
    end

    def with_retrying(tries: 10)
      tries.times do |try|
        response = yield

        if response.status.too_many_requests? && try < tries - 1
          sleep 0.5
        else
          return @last_response = response
        end
      end

      raise ApiLimitReachedError, "API limit reached, tried #{tries} times"
    end
  end
end
