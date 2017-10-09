# frozen_string_literal: true

module HotsApi
  module Models
    class Ability < Model
      attribute :owner, String
      attribute :name, String
      attribute :title, String
      attribute :description, String
      attribute :icon, String
      attribute :hotkey, String
      attribute :cooldown, Integer
      attribute :mana_cost, Integer
      attribute :mana_cost, Integer
      attribute :trait, Boolean
    end
  end
end
