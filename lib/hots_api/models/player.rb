# frozen_string_literal: true

module HotsApi
  module Models
    class Player < Model
      attribute :battletag, String
      attribute :hero, String
      attribute :hero_level, Integer
      attribute :team, Integer
      attribute :winner, Boolean
      attribute :blizz_id, Integer
    end
  end
end
