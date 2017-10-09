# frozen_string_literal: true

module HotsApi
  module Models
    class Hero < Model
      attribute :name, String
      attribute :short_name, String
      attribute :role, String
      attribute :type, String
      attribute :release_date, Date
      attribute :icon_url, Hash
      attribute :translations, Array[String]
      attribute :abilities, Array[Ability]
      attribute :talents, Array[Talent]
    end
  end
end
