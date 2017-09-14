# frozen_string_literal: true

module HotsApi
  module Models
    class UploadedReplay < Model
      attribute :id, Integer
      attribute :success, Boolean
      attribute :original_name, String
      attribute :status, String
      attribute :filename, String
      attribute :url, String

      def originalName=(name)
        self.original_name = name
      end

      def replay
        HotsApi.replays.find(id) if id
      end
    end
  end
end
