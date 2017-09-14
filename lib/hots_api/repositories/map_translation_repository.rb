# frozen_string_literal: true

module HotsApi
  module Repositories
    class MapTranslationRepository < Repository
      private

      def fetch_records
        response = HotsApi.get('maps/translations')

        response.parse.map do |map_translation|
          Models::MapTranslation.new(map_translation)
        end
      end
    end
  end
end
