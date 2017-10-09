require 'bundler/setup'
require 'hots_api'

Bundler.require

RSpec.configure do |config|
  config.include JSON::SchemaMatchers

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.json_schemas[:replay_schema] = 'spec/json_schemas/replay_schema.json'
  config.json_schemas[:replay_with_players_schema] = 'spec/json_schemas/replay_with_players_schema.json'
  config.json_schemas[:map_schema] = 'spec/json_schemas/map_schema.json'
  config.json_schemas[:hero_schema] = 'spec/json_schemas/hero_schema.json'
end
