# HotsApi

[![Build Status](https://travis-ci.org/tbuehlmann/hots_api.svg?branch=master)](https://travis-ci.org/tbuehlmann/hots_api)

HotsApi is an API client for the Heroes of the Storm replay metadata API [hotsapi.net](https://hotsapi.net/). It consumes the API and lets you retrieve information about uploaded replays.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hots_api'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install hots_api

## Finding Replays

#### Finding a Single Replay

```ruby
replay = HotsApi.replays.find(59) # => #<HotsApi::Models::Replay>
replay.id           # => 59
replay.filename     # => '04e92942-7a46-f12c-24f6-65dcf4ea409f'
replay.size         # => 1495665
replay.fingerprint  # => '04e92942-7a46-2cf1-24f6-65dcf4ea409f'
replay.game_date    # => 2017-08-15 23:16:28 +0200
replay.game_length  # => 872
replay.game_map     # => 'Braxis Holdout'
replay.game_type    # => 'HeroLeague'
replay.game_version # => '2.27.1.56361'
replay.bans         # => [['Dehaka', 'Anub'arak'], ['Sylvanas', 'Sonya']]
replay.region       # => 2
replay.processed    # => true
replay.url          # => 'http://hotsapi.s3-website-eu-west-1.amazonaws.com/04e92942-7a46-f12c-24f6-65dcf4ea409f.StormReplay'
replay.created_at   # => 2017-08-27 14:58:59 +0200
replay.updated_at   # => 2017-10-04 01:23:53 +0200
replay.players      # => [#<HotsApi::Models::Player>, …]

player = replay.players[2] # => #<HotsApi::Models::Player>
player.blizz_id   # => 215378
player.battletag  # => 'Poma'
player.hero       # => 'Chromie'
player.hero_level # => 13
player.team       # => 0
player.winner     # => true
player.party      # => 0
player.talents    # => {'1' => 'ChromieTimewalkersPursuit', '4' => 'ChromieBronzeTalons', '7' => 'ChromieDragonsBreathDragonsEye', '10' => 'ChromieHeroicAbilityTemporalLoop', '13' => 'ChromieReachingThroughTime', '16' => 'ChromieQuantumOverdrive'}
player.score      # => #<HotsApi::Models::Score>

score = player.score # => #<HotsApi::Models::Score>
score.level                   # => 16
score.kills                   # => 9
score.assists                 # => 14
score.takedowns               # => 23
score.deaths                  # => 1
score.highest_kill_streak     # => 23
score.hero_damage             # => 35902
score.siege_damage            # => 33200
score.structure_damage        # => 10571
score.minion_damage           # => 20839
score.creep_damage            # => 6686
score.summon_damage           # => 1790
score.time_cc_enemy_heroes    # => 5033
score.healing                 # => nil
score.self_healing            # => 0
score.damage_taken            # => nil
score.experience_contribution # => 7683
score.town_kills              # => 0
score.time_spent_dead         # => 44
score.merc_camp_captures      # => 3
score.watch_tower_captures    # => 0
score.meta_experience         # => 52960
```

#### Finding Replays

```ruby
replays = HotsApi.replays.to_a # => [#<HotsApi::Models::Replay>, …]
```

#### Filtering Replays

```ruby
# by game date
replays = HotsApi.replays.where(start_date: '2017-09-01 00:00').to_a
replays = HotsApi.replays.where(end_date: '2017-09-01 00:00').to_a

# by game map
replays = HotsApi.replays.where(game_map: 'Hanamura').to_a

# by game type
replays = HotsApi.replays.where(game_type: 'HeroLeague').to_a

# by id
replays = HotsApi.replays.where(min_id: 1000).to_a

# by player
replays = HotsApi.replays.where(player: 'Poma').to_a

# by hero
replays = HotsApi.replays.where(hero: 'Tassadar').to_a

# conditions are chainable
replays = HotsApi.replays.where(start_date: '2017-09-01 00:00', end_date: '2017-09-01 23:59').where(game_type: 'HeroLeague').to_a
```

Note: Filtering hero and map is disabled on the server right now, so you cannot use it.

#### Include Players

Replays don't include its players and bans per default. If you want to include them, use `with_players` (which is also chainable):

```ruby
replays = HotsApi.replays.with_players.to_a
replays = HotsApi.replays.where(start_date: '2017-09-01 00:00').with_players.to_a
```

#### Pagination

The API returns a maximum of 100 replays per request. If you want to retrieve the second page (or the next 100 replays) for a given query:

```ruby
first_page = HotsApi.replays
second_page = first_page.next_page
```

Internally, this will set the appropriate `min_id` to the query. If there's no next page, calling `next_page` will return `nil`.

If you want to retrieve all replays for a given query, use `find_each`:

```ruby
HotsApi.replays.where(start_date: '2017-09-01 00:00', end_date: '2017-09-01 23:59').find_each do |replay|
  # …
end

# or

replays = HotsApi.replays.where(start_date: '2017-09-01 00:00', end_date: '2017-09-01 23:59').find_each.to_a
```

Note that this might take some time, depending on the query's replay count.

## Replay Utilities

#### Uploading Replays

```ruby
uploaded_replay = HotsApi.replays.upload('/path/to/Garden of Terror.StormReplay') # => #<HotsApi::Models::UploadedReplay>
uploaded_replay.id            # => 2431959
uploaded_replay.filename      # => '1745472b-94a0-2b2d-3f14-8794717545fc'
uploaded_replay.original_name # => 'Garden of Terror.StormReplay'
uploaded_replay.status        # => 'duplicate'
uploaded_replay.success       # => true
uploaded_replay.url           # => 'http://hotsapi.s3-website-eu-west-1.amazonaws.com/1745472b-94a0-2b2d-3f14-8794717545fc.StormReplay'
```

You can also retrieve the replay for a given uploaded replay:

```ruby
uploaded_replay.replay # => #<HotsApi::Models::Replay>
```

#### Checking for Replay Existence

Check whether a given replay was uploaded by its fingerprint:

```ruby
HotsApi.replays.fingerprint_uploaded?('04e92942-7a46-2cf1-24f6-65dcf4ea409f') # => true
HotsApi.replays.fingerprint_uploaded?('non-existing-fingerprint') # => false
```

Check whether given replays were uploaded by its fingerprints:

```ruby
fingerprints = ['04e92942-7a46-2cf1-24f6-65dcf4ea409f', 'non-existing-fingerprint']
HotsApi.replays.fingerprints_uploaded?(fingerprints) # => {'04e92942-7a46-2cf1-24f6-65dcf4ea409f' => true, 'non-existing-fingerprint' => false}
```

#### Triggering HotsLogs Uploads

If there's a replay saved on HotsApi, you can trigger uploading it to HotsLogs usings its fingerprint:

```ruby
fingerprint = '04e92942-7a46-2cf1-24f6-65dcf4ea409f'
upload_triggered = HotsApi.replays.trigger_hotslogs_upload(fingerprint)

if upload_triggered
  puts 'Triggered HotsLogs upload'
else
  puts 'Replay for given fingerprint does not exist'
end
```

The actual uploading to HotsLogs happens from the HotsApi server, not your local computer.

#### Getting The Minimal Supported Build Version

```ruby
HotsApi.replays.minimum_supported_build # => 43905
```

## Finding Heroes

#### Finding a Single Hero

```ruby
hero = HotsApi.heroes.find('Tassadar') # => #<HotsApi::Models::Hero>
hero.name         # => 'Tassadar'
hero.short_name   # => 'tassadar'
hero.attribute_id # => 'Tass'
hero.role         # => 'Support'
hero.type         # => 'Ranged'
hero.release_date # => 2014-03-13
hero.icon_url     # => {'92x93' => 'http://s3.hotsapi.net/img/heroes/92x93/tassadar.png'}
hero.translations # => ['тассадар', '태사다르', '塔萨达尔', '塔薩達', 'tassadar']
hero.abilities    # => [#<HotsApi::Models::Ability>, …]

ability = hero.abilities[0] # => #<HotsApi::Models::Ability>
ability.name        # => 'D1'
ability.owner       # => 'Tassadar'
ability.title       # => 'Oracle'
ability.description # => 'Activate to greatly increase Tassadar's vision radius, allow him to see over obstacles, and detect stealthed units. Lasts for 5 seconds. Passive: Tassadar's Basic Attack is a Distortion Beam that slows enemy units by 20%.'
ability.icon        # => nil
ability.hotkey      # => 'D'
ability.cooldown    # => 30
ability.mana_cost   # => nil
ability.trait       # => true
```

#### Finding Heroes

```ruby
heroes = HotsApi.heroes.to_a # => [#<HotsApi::Models::Hero>, …]
```

## Finding Maps

#### Finding a Single Map

```ruby
map = HotsApi.maps.find('Tomb of the Spider Queen') # => #<HotsApi::Models::Map>
map.name         # => 'Tomb of the Spider Queen'
map.translations # => ['tumba de la reina araña', '蛛后之墓', 'tumba da aranha rainha', '거미 여왕의 무덤', 'tombe de la reine araignée', 'grabkammer der spinnenkönigin', 'grobowiec pajęczej królowej', 'tomba della regina ragno', 'гробница королевы пауков', '蛛后墓', 'tomb of the spider queen']
```

#### Finding Maps

```ruby
map = HotsApi.maps.to_a # => [#<HotsApi::Models::Map>, …]
```

## Finding Talents

#### Finding a Single Talent

```ruby
talent = HotsApi.talents.find('MalfurionRevitalizeInnervateTalent') # => #<HotsApi::Models::Talent>
talent.name        # => 'MalfurionRevitalizeInnervateTalent'
talent.title       # => 'Revitalize'
talent.description # => 'Using Innervate also grants Malfurion 50 Mana and causes his Cooldowns to refresh 50% faster for 5 seconds.'
talent.icon        # => 'storm_ui_icon_malfurion_innerrvate.png'
talent.icon_url    # => {'64x64' => 'http://s3.hotsapi.net/img/talents/64x64/storm_ui_icon_malfurion_innerrvate.png'}
talent.ability     # => 'D1'
talent.sort        # => 3
talent.cooldown    # => nil
talent.mana_cost   # => nil
talent.level       # => 16
talent.heroes      # => ['Malfurion']
```

#### Finding Talents

```ruby
map = HotsApi.talents.to_a # => [#<HotsApi::Models::Talent>, …]
```

## Rate Limiting

The API uses some kind of leaky bucket algorithm for rate limiting. It allows for a certain amount of requests in a given period of time and refills this pool of available requests every other second. The number of available requests depends on the resource you're requesting.

When the client requests the API and hits the request rate limit, it will sleep for a second and try again after that. It will retry 9 times for a given query. If it hits the rate limit on its last try, it will raise a `HotsApi::Fetcher::ApiLimitReachedError`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/tbuehlmann/hots_api).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
