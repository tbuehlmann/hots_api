# frozen_string_literal: true

module HotsApi
  module Repositories
    class Repository
      include Enumerable

      def initialize_copy(_original)
        @records = nil
      end

      def find(id)
        response = HotsApi.get("#{path}/#{id}")

        if response.status.ok?
          model.new(response.parse)
        end
      end

      def where(conditions = {})
        spawn do |repository|
          conditions.each do |attribute, value|
            if respond_to?("#{attribute}=", true)
              send("#{attribute}=", value)
            else
              raise "Unknown attribute: #{attribute}"
            end
          end
        end
      end

      def next_page
        if records.any?
          where(min_id: records.last.id + 1)
        end
      end

      def each(&block)
        records.each(&block)
      end

      def find_each(&block)
        find_each_enum.each(&block)
      end

      def last(n = nil)
        n ? records.last(n) : records.last
      end

      def spawn(&block)
        clone.tap do |repository|
          repository.instance_exec(&block)
        end
      end

      private

      def find_each_enum
        Enumerator.new do |yielder|
          page = self

          while page && page.any?
            page.each { |model| yielder << model }
            page = page.next_page
          end
        end
      end

      def where_values
        @where_values ||= {}
      end

      def records
        @records ||= fetch_records
      end

      def fetch_records
        response = HotsApi.get(path, params: where_values)

        response.parse.map do |attributes|
          model.new(attributes)
        end
      end

      def path
        raise NotImplementedError
      end

      def model
        raise NotImplementedError
      end
    end
  end
end
