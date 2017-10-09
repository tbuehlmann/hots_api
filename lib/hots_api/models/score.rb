# frozen_string_literal: true

module HotsApi
  module Models
    class Score < Model
      attribute :level, Integer
      attribute :kills, Integer
      attribute :assists, Integer
      attribute :takedowns, Integer
      attribute :deaths, Integer
      attribute :highest_kill_streak, Integer
      attribute :hero_damage, Integer
      attribute :siege_damage, Integer
      attribute :structure_damage, Integer
      attribute :minion_damage, Integer
      attribute :creep_damage, Integer
      attribute :summon_damage, Integer
      attribute :time_cc_enemy_heroes, Integer
      attribute :healing, Integer
      attribute :self_healing, Integer
      attribute :damage_taken, Integer
      attribute :experience_contribution, Integer
      attribute :town_kills, Integer
      attribute :time_spent_dead, Integer
      attribute :merc_camp_captures, Integer
      attribute :watch_tower_captures, Integer
      attribute :meta_experience, Integer
    end
  end
end
