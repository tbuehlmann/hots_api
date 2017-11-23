# frozen_string_literal: true

module HotsApi
  module Repositories
    class TalentRepository < SimpleRepository
      private

      def instantiate_record_with(attributes)
        Models::Talent.new(attributes)
      end

      def collection_path
       'talents'
      end
    end
  end
end
