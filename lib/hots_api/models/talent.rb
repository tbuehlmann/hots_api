# frozen_string_literal: true

module HotsApi
  module Models
    class Talent < Model
      attribute :name, String
      attribute :title, String
      attribute :description, String
      attribute :icon, String
      attribute :icon_url, Hash
      attribute :ability, String
      attribute :sort, Integer
      attribute :cooldown, Integer
      attribute :mana_cost, Integer
      attribute :level, Integer
    end
  end
end
