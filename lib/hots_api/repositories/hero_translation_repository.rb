# frozen_string_literal: true

module HotsApi
  module Repositories
    class HeroTranslationRepository < Repository
      private

      def path
        'heroes/translations'
      end

      def model
        Models::HeroTranslation
      end
    end
  end
end
