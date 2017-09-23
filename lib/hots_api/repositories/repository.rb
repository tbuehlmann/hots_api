# frozen_string_literal: true

module HotsApi
  module Repositories
    class Repository
      include Enumerable

      def initialize(where_values: {})
        @where_values = where_values
      end

      def find(id)
        response = HotsApi.get("#{collection_path}/#{id}")

        if response.status.ok?
          instantiate_record_for(response.parse)
        end
      end

      def where(conditions = {})
        copy do
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
        if @records.any?
          where(min_id: @records.last.id + 1)
        else

        end
      end

      def each(&block)
        fetch { @records.each(&block) }
      end

      def find_each(&block)
        find_each_enum.each(&block)
      end

      def last(n = nil)
        fetch { n ? @records.last(n) : @records.last }
      end

      def size
        fetch { @records.size }
      end

      def length
        fetch { @records.length }
      end

      private

      def copy(&block)
        self.class.new(where_values: @where_values.clone, &block).tap do |repository|
          repository.instance_exec(&block)
        end
      end

      def fetched?
        @fetched
      end

      def fetch
        unless @fetched
          response = HotsApi.get(collection_path, params: @where_values)
          @records = instantiate_records(response.parse)

          @fetched = true
        end

        yield
      end

      def find_each_enum
        Enumerator.new do |yielder|
          page = self

          while page && page.any?
            page.each { |model| yielder << model }
            page = page.next_page
          end
        end
      end

      def instantiate_records(json)
        json.map do |attributes|
          instantiate_record_with(attributes)
        end
      end

      def instantiate_record_with(attributes)
        raise NotImplementedError
      end

      def collection_path
        raise NotImplementedError
      end
    end
  end
end
