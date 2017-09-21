# frozen_string_literal: true

module HotsApi
  module Repositories
    class HeroTranslationRepository < SimpleRepository
      private

      def instantiate_record_for(attributes)
        Models::HeroTranslation.new(attributes)
      end

      def collection_path
        'heroes/translations'
      end
    end
  end
end
