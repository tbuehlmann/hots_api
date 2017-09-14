# frozen_string_literal: true

module HotsApi
  module Repositories
    class HeroTranslationRepository < Repository
      private

      def fetch_records
        response = HotsApi.get('heroes/translations')

        response.parse.map do |hero_translation|
          Models::HeroTranslation.new(hero_translation)
        end
      end
    end
  end
end
