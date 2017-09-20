# frozen_string_literal: true

module HotsApi
  module Repositories
    class ReplayRepository < Repository
      def upload(file)
        response = HotsApi.post(path, file: file)
        Models::UploadedReplay.new(response.parse)
      end

      def trigger_hotslogs_upload(fingerprint)
        HotsApi.get("#{path}/fingerprints/v3/#{fingerprint}", params: {uploadToHotslogs: 1}).parse['exists']
      end

      def fingerprint_uploaded?(fingerprint)
        HotsApi.get("#{path}/fingerprints/v3/#{fingerprint}").parse['exists']
      end

      def fingerprints_uploaded?(fingerprints)
        return {} if fingerprints.empty?

        upload_statuses = HotsApi.post("#{path}/fingerprints", body: fingerprints.join("\n")).parse

        {}.tap do |fingerprint_statuses|
          upload_statuses['exists'].each do |fingerprint|
            fingerprint_statuses[fingerprint] = true
          end

          upload_statuses['absent'].each do |fingerprint|
            fingerprint_statuses[fingerprint] = false
          end
        end
      end

      def minimum_supported_build
        HotsApi.get("#{path}/min-build").to_s.to_i
      end

      def with_players
        spawn { where_values[:with_players] = 1 }
      end

      private

      def start_date=(date)
        where_values[:start_date] = date_string_for(date)
      end

      def end_date=(date)
        where_values[:end_date] = date_string_for(date)
      end

      def game_type=(game_type)
        where_values[:game_type] = game_type
      end

      def min_id=(id)
        where_values[:min_id] = id
      end

      def player=(player)
        where_values[:player] = player
      end

      def hero=(hero)
        where_values[:hero] = hero
      end

      def date_string_for(date)
        if date.respond_to?(:strftime)
          date.strftime('%F %T')
        else
          date.to_s
        end
      end

      def path
        'replays'
      end

      def model
        Models::Replay
      end
    end
  end
end
