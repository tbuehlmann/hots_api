require 'spec_helper'

# These specs make sure we're up to date with API responses
RSpec.describe 'API v1' do
  describe 'replays' do
    it 'GET /replays returns replays' do
      response = HTTP.get('http://hotsapi.net/api/v1/replays')
      expect(response.parse).to eq(api_response_for('replays'))
    end

    it 'GET /replays?start_date=2017-09-01 returns replays' do
      response = HTTP.get('http://hotsapi.net/api/v1/replays?start_date=2017-09-01')
      expect(response.parse).to eq(api_response_for('replays_with_start_date'))
    end

    it 'GET /replays?end_date=2017-07-01 returns replays' do
      response = HTTP.get('http://hotsapi.net/api/v1/replays?end_date=2017-07-01')
      expect(response.parse).to eq(api_response_for('replays_with_end_date'))
    end

    it 'GET /replays?game_map=Hanamura returns replays' do
      response = HTTP.get('http://hotsapi.net/api/v1/replays?game_map=Hanamura')
      expect(response.parse).to eq(api_response_for('replays_with_game_map'))
    end

    it 'GET /replays?game_type=HeroLeague returns replays' do
      response = HTTP.get('http://hotsapi.net/api/v1/replays?game_type=HeroLeague')
      expect(response.parse).to eq(api_response_for('replays_with_game_type'))
    end

    it 'GET /replays?min_id=500 returns replays' do
      response = HTTP.get('http://hotsapi.net/api/v1/replays?min_id=500')
      expect(response.parse).to eq(api_response_for('replays_with_min_id'))
    end

    it 'GET /replays?player=Poma returns replays' do
      response = HTTP.get('http://hotsapi.net/api/v1/replays?player=Poma')
      expect(response.parse).to eq(api_response_for('replays_with_player'))
    end

    it 'GET /replays?hero=Tassadar returns replays' do
      response = HTTP.get('http://hotsapi.net/api/v1/replays?hero=Tassadar')
      expect(response.parse).to eq(api_response_for('replays_with_hero'))
    end

    it 'GET /replays?with_players=1 returns replays' do
      response = HTTP.get('http://hotsapi.net/api/v1/replays?with_players=1')
      expect(response.parse).to eq(api_response_for('replays_with_players'))
    end

    it 'GET /replays/1 returns a replay' do
      response = HTTP.get('http://hotsapi.net/api/v1/replays/1')
      expect(response.parse).to eq(api_response_for('replay'))
    end

    describe 'fingerprints' do
      describe 'GET /replays/fingerprints/v3/:fingerprint' do
        it 'returns truthy for an existing fingerprint' do
          response = HTTP.get('http://hotsapi.net/api/v1/replays/fingerprints/v3/725ba498-2728-26d3-b6ac-11129c55b212')
          expect(response.parse).to eq('exists' => true)
        end

        it 'returns falsy for a non existing fingerprint' do
          response = HTTP.get('http://hotsapi.net/api/v1/replays/fingerprints/v3/non-existing-fingerprint')
          expect(response.parse).to eq('exists' => false)
        end
      end

      describe 'POST /replays/fingerprints' do
        let(:existing_fingerprint) { '725ba498-2728-26d3-b6ac-11129c55b212' }
        let(:non_existing_fingerprint) { 'non-existing-fingerprint' }

        it 'returns fingerprints for just existing fingerprints' do
          response = HTTP.post('http://hotsapi.net/api/v1/replays/fingerprints', body: existing_fingerprint)
          expect(response.parse).to eq('exists' => [existing_fingerprint], 'absent' => [])
        end

        it 'returns fingerprints for just non existing fingerprints' do
          response = HTTP.post('http://hotsapi.net/api/v1/replays/fingerprints', body: non_existing_fingerprint)
          expect(response.parse).to eq('exists' => [], 'absent' => [non_existing_fingerprint])
        end

        it 'returns fingerprints (in a different format!) for existing and non existing fingerprints' do
          response = HTTP.post('http://hotsapi.net/api/v1/replays/fingerprints', body: [existing_fingerprint, non_existing_fingerprint].join("\n"))
          expect(response.parse).to eq('exists' => [existing_fingerprint], 'absent' => [non_existing_fingerprint])
        end
      end
    end
  end

  describe 'hero translations' do
    it 'GET /heroes/translations returns hero translations' do
      hero_translations = HTTP.get('http://hotsapi.net/api/v1/heroes/translations').parse

      expect(hero_translations).to be_an(Array)
      expect(hero_translations.first).to have_exactly(2).items
      expect(hero_translations.first['name']).to be_a(String)
      expect(hero_translations.first['versions']).to be_an(Array)
      expect(hero_translations.first['versions']).to all(be_a(String))
    end
  end

  describe 'map translations' do
    it 'GET /maps/translations returns map translations' do
      hero_translations = HTTP.get('http://hotsapi.net/api/v1/maps/translations').parse

      expect(hero_translations).to be_an(Array)
      expect(hero_translations.first).to have_exactly(2).items
      expect(hero_translations.first['name']).to be_a(String)
      expect(hero_translations.first['versions']).to be_an(Array)
      expect(hero_translations.first['versions']).to all(be_a(String))
    end
  end

  describe 'minimum_supported_build' do
    it 'GET /replays/min-build returns a build' do
      response = HTTP.get('http://hotsapi.net/api/v1/replays/min-build')
      expect(response.to_s.to_i).to be > 0
    end
  end

  def api_response_for(name)
    path = Pathname.new(__dir__) / 'api_responses' / "#{name}.json"
    JSON.parse(path.read)
  end
end
