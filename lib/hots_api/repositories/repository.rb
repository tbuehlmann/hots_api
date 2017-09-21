# frozen_string_literal: true

module HotsApi
  module Repositories
    class Repository
      include Enumerable

      def initialize(where_values: {})
        @where_values = where_values
      end

      def find(id)
        response = HotsApi.get("#{object_path}/#{id}")

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

      def page(number = nil)
        if number
          copy { @where_values[:page] = number }
        else
          @where_values.fetch(:page, 1)
        end
      end

      def previous_page
        if page == 1
          self
        else
          copy { @where_values[:page] = page - 1 }
        end
      end

      def next_page
        copy { @where_values[:page] = page + 1 }
      end

      def pages
        fetch { @pages }
      end

      def count(&block)
        if block_given?
          fetch { @records.count(&block) }
        else
          fetch { @count }
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

      def page=(number)
        @where_values[:page] = number
      end

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
          handle(response.parse)

          @fetched = true
        end

        yield
      end

      def handle(json)
        @records = instantiate_records_for(json)
        @where_values[:page] = json['page']

        @pages = json['page_count']
        @count = json['total']
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

      def instantiate_records_for(json)
        json[pluralized_model_name].map do |attributes|
          instantiate_record_for(attributes)
        end
      end

      def pluralized_model_name
        raise NotImplementedError
      end

      def instantiate_record_for(attributes)
        raise NotImplementedError
      end

      def object_path
        raise NotImplementedError
      end

      def collection_path
        raise NotImplementedError
      end
    end
  end
end
