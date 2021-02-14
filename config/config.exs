import Config

config :logger,
  level: :info

config :nostrum,
  num_shards: :auto

import_config "token.exs"
