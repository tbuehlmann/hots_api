# HotsApi

[![Build Status](https://travis-ci.org/tbuehlmann/hots_api.svg?branch=master)](https://travis-ci.org/tbuehlmann/hots_api)

HotsApi is an API client for the Heroes of the Storm replay metadata API [hotsapi.net](http://hotsapi.net/). It consumes the API and lets you retrieve information about uploaded replays.

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
replay.fingerprint  # => '04e92942-7a46-2cf1-24f6-65dcf4ea409f'
replay.game_date    # => 2017-08-15 23:16:28 +0200
replay.game_length  # => 872
replay.game_map     # => 'Braxis Holdout'
replay.game_type    # => 'HeroLeague'
replay.game_version # => '2.27.1.56361'
replay.players      # => [#<HotsApi::Models::Player>, …]

player = replay.players[0] # => #<HotsApi::Models::Player>
player.blizz_id   # => 215378
player.battletag  # => 'Poma'
player.hero       # => 'Chromie'
player.hero_level # => 13
player.team       # => 0
player.winner     # => true
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

#### Include Players

Replays don't include its players per default. If you want to include players, use `with_players` (which is also chainable):

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

If there's a replay saved on HotsApi, you can trigger uploading it to HotsLogs by its fingerprint:

```ruby
fingerprint = '04e92942-7a46-2cf1-24f6-65dcf4ea409f'
upload_triggered = HotsApi.replays.trigger_hotslogs_upload(fingerprint)

if upload_triggered
  puts 'Triggered HotsLogs upload'
else
  puts 'Replay for given fingerprint does not exist'
end
```

The actual uploading to HotsLogs happens from the HotsApi server.

#### Getting The Minimal Supported Build Version

```ruby
HotsApi.replays.minimum_supported_build # => 43905
```

## Finding Hero Translations

```ruby
hero_translations = HotsApi.hero_translations.to_a # => [#<HotsApi::Models::HeroTranslation>, …]

hero_translation = hero_translations[0] # => #<HotsApi::Models::HeroTranslation>
hero_translation.name     # => 'Abathur'
hero_translation.versions # => ['abatur', 'абатур', '아바투르', '阿巴瑟', 'abathur']
```

## Finding Map Translations

```ruby
map_translations = HotsApi.map_translations.to_a # => [#<HotsApi::Models::MapTranslation>, …]

map_translation = map_translations[0] # => #<HotsApi::Models::MapTranslation>
map_translation.name     # => 'Battlefield of Eternity'
map_translation.versions # => ["campo de batalha da eternidade", "campo de batalla de la eternidad", "永恆戰場", "永恒战场", "영원의 전쟁터", "campos de batalla de la eternidad", "schlachtfeld der ewigkeit", "champs de l’éternité", "вечная битва", "campi di battaglia eterni", "pole bitewne wieczności", "battlefield of eternity"]
```

## Rate Limiting

The API probably uses some kind of leaky bucket algorithm for rate limiting. It allows for 300 requests in a short period of time and refills this pool of available requests every other second.

When the client requests the API and hits the request rate limit, it will sleep for 0.5 seconds and try again after that. It will retry 9 times for a given query. If it hits the rate limit on its last try, it will raise a `HotsApi::Fetcher::ApiLimitReachedError`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/tbuehlmann/hots_api).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
