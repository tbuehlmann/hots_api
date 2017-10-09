# frozen_string_literal: true

module HotsApi
  module Repositories
    class MapRepository < SimpleRepository
      private

      def instantiate_record_with(attributes)
        Models::Map.new(attributes)
      end

      def collection_path
       'maps'
      end
    end
  end
end
