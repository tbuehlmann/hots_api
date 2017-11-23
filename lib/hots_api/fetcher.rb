# frozen_string_literal: true

require 'http'

module HotsApi
  class Fetcher
    ApiLimitReachedError = Class.new(StandardError)

    attr_reader :last_response

    def get(path, params: {})
      with_retrying do
        HTTP.get("#{base_path}/#{path}", params: params)
      end
    end

    def post(path, body: nil, file: nil)
      with_retrying do
        HTTP.post("#{base_path}/#{path}", post_options_for(body: body, file: file))
      end
    end

    private

    def post_options_for(body:, file:)
      {}.tap do |options|
        options[:body] = body if body
        options[:form] = {file: HTTP::FormData::File.new(file)} if file
      end
    end

    def base_path
      'https://hotsapi.net/api/v1'
    end

    def with_retrying(tries: 10)
      tries.times do |try|
        response = yield

        if response.status.too_many_requests?
          if try < tries - 1
            sleep 1
          else
            raise ApiLimitReachedError, "API limit reached, tried #{tries} times"
          end
        else
          return @last_response = response
        end
      end
    end
  end
end
