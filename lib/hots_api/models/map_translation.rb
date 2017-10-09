# frozen_string_literal: true

module HotsApi
  module Models
    class MapTranslation < Model
      attribute :name, String
      attribute :translations, Array[String]
    end
  end
end
