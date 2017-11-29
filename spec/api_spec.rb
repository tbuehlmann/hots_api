require 'spec_helper'

# These specs make sure we're up to date with API responses
RSpec.describe 'API v1', :sleep do
  describe 'replays' do
    it 'GET /replays returns replays' do
      replays = HTTP.get('https://hotsapi.net/api/v1/replays').parse

      expect(replays).to have_at_least(1).item
      expect(replays).to match_json_schema(:replay_schema, strict: true, list: true, clear_cache: true)
    end

    describe 'filtering' do
      it 'GET /replays?start_date=2017-09-01 returns replays' do
        replays = HTTP.get('https://hotsapi.net/api/v1/replays?start_date=2017-09-01').parse
        start_date = Time.parse('2017-09-01')
        expect(replays).to have_at_least(1).item

        replays.each do |replay|
          game_date = Time.parse(replay['game_date'])
          expect(game_date).to be >= start_date
        end
      end

      it 'GET /replays?end_date=2017-07-01 returns replays' do
        replays = HTTP.get('https://hotsapi.net/api/v1/replays?end_date=2017-07-01').parse
        end_date = Time.parse('2017-07-01')
        expect(replays).to have_at_least(1).item

        replays.each do |replay|
          game_date = Time.parse(replay['game_date'])
          expect(game_date).to be <= end_date
        end
      end

      it 'GET /replays?game_map=Hanamura returns replays' do
        skip 'deactivated on hotsapi.net right now'

        replays = HTTP.get('https://hotsapi.net/api/v1/replays?game_map=Hanamura').parse
        expect(replays).to have_at_least(1).item

        replays.each do |replay|
          expect(game_date).to eq('Hanamura')
        end
      end

      it 'GET /replays?game_type=HeroLeague returns replays' do
        replays = HTTP.get('https://hotsapi.net/api/v1/replays?game_type=HeroLeague').parse
        expect(replays).to have_at_least(1).item

        replays.each do |replay|
          expect(replay['game_type']).to eq('HeroLeague')
        end
      end

      it 'GET /replays?min_id=500 returns replays' do
        replays = HTTP.get('https://hotsapi.net/api/v1/replays?min_id=500').parse
        expect(replays).to have_at_least(1).item

        replays.each do |replay|
          expect(replay['id']).to be >= 500
        end
      end

      it 'GET /replays?player=Poma%232204&with_players=1 returns replays' do
        replays = HTTP.get('https://hotsapi.net/api/v1/replays?player=Poma%232204&with_players=1').parse
        expect(replays).to have_at_least(1).item

        replays.each do |replay|
          battletags = replay['players'].map { |player| player['battletag'] }
          expect(battletags).to include('Poma#2204')
        end
      end

      it 'GET /replays?hero=Tassadar returns replays' do
        skip 'deactivated on hotsapi.net right now'
      end

      it 'GET /replays?with_players=1 returns replays' do
        replays = HTTP.get('https://hotsapi.net/api/v1/replays?with_players=1').parse

        expect(replays).to have_at_least(1).item
        expect(replays).to match_json_schema(:replay_with_players_and_bans_schema, strict: true, list: true, clear_cache: true)
      end

      it 'GET /replays/1 returns a replay' do
        replay = HTTP.get('https://hotsapi.net/api/v1/replays/1').parse
        expect(replay).to match_json_schema(:replay_with_players_and_bans_schema, strict: true, clear_cache: true)
      end
    end

    describe 'fingerprints' do
      describe 'GET /replays/fingerprints/v3/:fingerprint' do
        it 'returns truthy for an existing fingerprint' do
          response = HTTP.get('https://hotsapi.net/api/v1/replays/fingerprints/v3/725ba498-2728-26d3-b6ac-11129c55b212')
          expect(response.parse).to eq('exists' => true)
        end

        it 'returns falsy for a non existing fingerprint' do
          response = HTTP.get('https://hotsapi.net/api/v1/replays/fingerprints/v3/non-existing-fingerprint')
          expect(response.parse).to eq('exists' => false)
        end
      end

      describe 'POST /replays/fingerprints' do
        let(:existing_fingerprint) { '725ba498-2728-26d3-b6ac-11129c55b212' }
        let(:non_existing_fingerprint) { 'non-existing-fingerprint' }

        it 'returns fingerprints for just existing fingerprints' do
          response = HTTP.post('https://hotsapi.net/api/v1/replays/fingerprints', body: existing_fingerprint)
          expect(response.parse).to eq('exists' => [existing_fingerprint], 'absent' => [])
        end

        it 'returns fingerprints for just non existing fingerprints' do
          response = HTTP.post('https://hotsapi.net/api/v1/replays/fingerprints', body: non_existing_fingerprint)
          expect(response.parse).to eq('exists' => [], 'absent' => [non_existing_fingerprint])
        end

        it 'returns fingerprints (in a different format!) for existing and non existing fingerprints' do
          response = HTTP.post('https://hotsapi.net/api/v1/replays/fingerprints', body: [existing_fingerprint, non_existing_fingerprint].join("\n"))
          expect(response.parse).to eq('exists' => [existing_fingerprint], 'absent' => [non_existing_fingerprint])
        end
      end
    end
  end

  describe 'heroes' do
    it 'GET /heroes returns heroes' do
      heroes = HTTP.get('https://hotsapi.net/api/v1/heroes').parse

      expect(heroes).to have_at_least(1).item
      expect(heroes).to match_json_schema(:hero_schema, strict: true, list: true, clear_cache: true)
    end

    it 'GET /heroes/Tassadar returns a hero' do
      heroes = HTTP.get('https://hotsapi.net/api/v1/heroes/Tassadar').parse
      expect(heroes).to match_json_schema(:hero_schema, strict: true, clear_cache: true)
    end
  end

  describe 'maps' do
    it 'GET /maps returns maps' do
      maps = HTTP.get('https://hotsapi.net/api/v1/maps').parse

      expect(maps).to have_at_least(1).item
      expect(maps).to match_json_schema(:map_schema, strict: true, list: true, clear_cache: true)
    end

    it 'GET /maps/Hanamura returns a map' do
      heroes = HTTP.get('https://hotsapi.net/api/v1/maps/Hanamura').parse
      expect(heroes).to match_json_schema(:map_schema, strict: true, clear_cache: true)
    end
  end

  describe 'talents' do
    it 'GET /talents returns talents' do
      talents = HTTP.get('https://hotsapi.net/api/v1/talents').parse

      expect(talents).to have_at_least(1).item
      expect(talents).to match_json_schema(:talent_schema, strict: true, list: true, clear_cache: true)
    end

    it 'GET /talents/MalfurionRevitalizeInnervateTalent returns a talent' do
      heroes = HTTP.get('https://hotsapi.net/api/v1/talents/MalfurionRevitalizeInnervateTalent').parse
      expect(heroes).to match_json_schema(:talent_schema, strict: true, clear_cache: true)
    end
  end

  describe 'minimum_supported_build' do
    it 'GET /replays/min-build returns a build' do
      response = HTTP.get('https://hotsapi.net/api/v1/replays/min-build')
      expect(response.to_s.to_i).to be > 0
    end
  end
end
