# frozen_string_literal: true

module HotsApi
  module Repositories
    class MapTranslationRepository < SimpleRepository
      private

      def instantiate_record_for(attributes)
        Models::MapTranslation.new(attributes)
      end

      def collection_path
       'maps/translations'
      end
    end
  end
end
