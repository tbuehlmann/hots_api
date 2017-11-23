# frozen_string_literal: true

require_relative 'hots_api/fetcher'
require_relative 'hots_api/version'

require_relative 'hots_api/models/model'
require_relative 'hots_api/models/ability'
require_relative 'hots_api/models/talent'
require_relative 'hots_api/models/hero'
require_relative 'hots_api/models/map'
require_relative 'hots_api/models/score'
require_relative 'hots_api/models/player'
require_relative 'hots_api/models/replay'
require_relative 'hots_api/models/uploaded_replay'
require_relative 'hots_api/models/talent'

require_relative 'hots_api/repositories/repository'
require_relative 'hots_api/repositories/simple_repository'
require_relative 'hots_api/repositories/hero_repository'
require_relative 'hots_api/repositories/map_repository'
require_relative 'hots_api/repositories/replay_repository'
require_relative 'hots_api/repositories/talent_repository'

module HotsApi
  def self.fetcher
    @fetcher ||= Fetcher.new
  end

  def self.get(path, params: {})
    fetcher.get(path, params: params)
  end

  def self.post(path, body: nil, file: nil)
    fetcher.post(path, body: body, file: file)
  end

  def self.replays
    Repositories::ReplayRepository.new
  end

  def self.heroes
    Repositories::HeroRepository.new
  end

  def self.maps
    Repositories::MapRepository.new
  end

  def self.talents
    Repositories::TalentRepository.new
  end
end
