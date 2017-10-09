# frozen_string_literal: true

module HotsApi
  module Models
    class Replay < Model
      attribute :id, Integer
      attribute :filename, String
      attribute :size, Integer
      attribute :game_type, String
      attribute :game_date, Time
      attribute :game_map, String
      attribute :game_length, Integer
      attribute :game_version, String
      attribute :fingerprint, String
      attribute :region, Integer
      attribute :processed, Boolean
      attribute :url, String
      attribute :created_at, Time
      attribute :updated_at, Time

      attribute :players, Array[Player]

      def reload
        tap do
          self.attributes = HotsApi.replays.find(id).attributes
        end
      end
    end
  end
end
