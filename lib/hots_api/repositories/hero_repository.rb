# frozen_string_literal: true

module HotsApi
  module Repositories
    class HeroRepository < SimpleRepository
      private

      def instantiate_record_with(attributes)
        Models::Hero.new(attributes)
      end

      def collection_path
        'heroes'
      end
    end
  end
end
