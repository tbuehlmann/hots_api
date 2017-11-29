require 'spec_helper'

RSpec.describe HotsApi::Repositories::ReplayRepository, :sleep do
  describe '#trigger_hotslogs_upload' do
    it 'returns true if a replay with the fingerprint was uploaded' do
      expect(subject.trigger_hotslogs_upload('725ba498-2728-26d3-b6ac-11129c55b212')).to eq(true)
    end

    it 'returns false if a replay with the fingerprint was not uploaded' do
      expect(subject.trigger_hotslogs_upload('non-existing-fingerprint')).to eq(false)
    end
  end

  describe '#fingerprint_uploaded?' do
    it 'returns true if a replay with the fingerprint was uploaded' do
      expect(subject.fingerprint_uploaded?('725ba498-2728-26d3-b6ac-11129c55b212')).to eq(true)
    end

    it 'returns false if a replay with the fingerprint was not uploaded' do
      expect(subject.fingerprint_uploaded?('non-existing-fingerprint')).to eq(false)
    end
  end

  describe '#fingerprints_uploaded?' do
    let(:existing_fingerprint) { '725ba498-2728-26d3-b6ac-11129c55b212' }
    let(:non_existing_fingerprint) { 'non-existing-fingerprint' }

    context 'without any fingerprints provided' do
      it 'returns an empty hash' do
        status = subject.fingerprints_uploaded?([])
        expect(status).to eq({})
      end
    end

    context 'with just existing fingerprints' do
      it 'returns a hash containing the fingerprints' do
        status = subject.fingerprints_uploaded?([existing_fingerprint])
        expect(status).to eq(existing_fingerprint => true)
      end
    end

    context 'with just non existing fingerprints' do
      it 'returns a hash containing the fingerprints' do
        status = subject.fingerprints_uploaded?([non_existing_fingerprint])
        expect(status).to eq(non_existing_fingerprint => false)
      end
    end

    context 'with existing and non existing fingerprints' do
      it 'returns a hash containing the fingerprints' do
        status = subject.fingerprints_uploaded?([existing_fingerprint, non_existing_fingerprint])
        expect(status).to eq(existing_fingerprint => true, non_existing_fingerprint => false)
      end
    end
  end

  describe '#minimum_supported_build' do
    it 'returns a positive number' do
      expect(subject.minimum_supported_build).to be > 0
    end
  end

  describe '#where' do
    it 'filters by start_date using a string' do
      replays = subject.where(start_date: '2017-09-01').to_a
      expect(replays).to have(100).replays

      replays.each do |replay|
        expect(replay.game_date).to be >= Time.parse('2017-09-01')
      end
    end

    it 'filters by start_date using a time' do
      replays = subject.where(start_date: Time.parse('2017-09-01 06:30:15')).to_a
      expect(replays).to have(100).replays

      replays.each do |replay|
        expect(replay.game_date).to be >= Time.parse('2017-09-01')
      end
    end

    it 'filters by end_date using a string' do
      replays = subject.where(end_date: '2017-07-01').to_a
      expect(replays).to have(100).replays

      replays.each do |replay|
        expect(replay.game_date).to be <= Time.parse('2017-07-01')
      end
    end

    it 'filters by end_date using a time' do
      replays = subject.where(end_date: Time.parse('2017-07-01 06:30:15')).to_a
      expect(replays).to have(100).replays

      replays.each do |replay|
        expect(replay.game_date).to be <= Time.parse('2017-07-01 06:30:15')
      end
    end

    it 'filters by game_map' do
      skip 'returns a 500 right now'

      replays = subject.where(game_map: 'Hanamura').to_a
      expect(replays).to have(100).replays

      replays.each do |replay|
        expect(replay.game_map).to eq('Hanamura')
      end
    end

    it 'filters by game_type' do
      replays = subject.where(game_type: 'HeroLeague').to_a
      expect(replays).to have(100).replays

      replays.each do |replay|
        expect(replay.game_type).to eq('HeroLeague')
      end
    end

    it 'filters by min_id' do
      replays = subject.where(min_id: 1000).to_a
      expect(replays).to have(100).replays

      replays.each do |replay|
        expect(replay.id).to be >= 1000
      end
    end

    it 'filters by player' do
      skip 'deactivated on hotsapi.net right now'

      replays = subject.with_players.where(player: 'Poma').to_a
      expect(replays).to have(100).replays

      replays.each do |replay|
        battletags = replay.players.map(&:battletag)
        expect(battletags).to include('Poma')
      end
    end

    it 'filters by hero' do
      skip 'deactivated on hotsapi.net right now'

      replays = subject.with_players.where(hero: 'Tassadar').to_a
      expect(replays).to have(100).replays

      replays.each do |replay|
        heroes = replay.players.map(&:hero)
        expect(heroes).to include('Tassadar')
      end
    end
  end

  describe '#with_players' do
    it 'includes players' do
      replays = subject.with_players.to_a
      expect(replays).to have(100).replays

      replays.each do |replay|
        expect(replay.players).to have(10).players
      end
    end
  end
end
