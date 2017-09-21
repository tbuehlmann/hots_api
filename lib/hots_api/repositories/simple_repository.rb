# frozen_string_literal: true

module HotsApi
  module Repositories
    class SimpleRepository
      include Enumerable

      def each(&block)
        records.each(&block)
      end

      def last(n = nil)
        n ? records.last(n) : records.last
      end

      def size
        records.size
      end

      def length
        records.length
      end

      private

      def records
        @records ||= fetch_records
      end

      def fetch_records
        response = HotsApi.get(collection_path)

        response.parse.map do |attributes|
          instantiate_record_for(attributes)
        end
      end

      def collection_path
        raise NotImplementedError
      end
    end
  end
end
