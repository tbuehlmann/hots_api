# frozen_string_literal: true

module HotsApi
  module Models
    class Player < Model
      attribute :hero, String
      attribute :hero_level, Integer
      attribute :team, Integer
      attribute :winner, Boolean
      attribute :blizz_id, Integer
      attribute :party, Integer
      attribute :silenced, Boolean
      attribute :battletag, String
      attribute :talents, Hash
      attribute :score, Score
    end
  end
end
