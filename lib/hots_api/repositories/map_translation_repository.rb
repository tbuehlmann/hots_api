# frozen_string_literal: true

module HotsApi
  module Repositories
    class MapTranslationRepository < Repository
      private

      def path
       'maps/translations'
      end

      def model
        Models::MapTranslation
      end
    end
  end
end
