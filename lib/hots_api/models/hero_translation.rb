# frozen_string_literal: true

module HotsApi
  module Models
    class HeroTranslation < Model
      attribute :name, String
      attribute :versions, Array[String]
    end
  end
end
