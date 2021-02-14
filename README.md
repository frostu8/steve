# Steve (Harvey)
A Discord bot that plays the famous song 
[Sex](https://www.youtube.com/watch?v=9DbXmreD_go), composed for the game
Steve Harvey, on loop, forever and ever (until you tell it to stop with
`steve!leave`).

## Usage
If you're administrator, you can use `steve!join` and `steve!leave`. Both
commands do exactly what you think they do.

## Run It Yourself
This requires [Elixir](https://elixir-lang.org/install.html) to run. Clone this 
repository with `git clone https://github.com/frostu8/steve.git`, cd into the 
source directory and run `mix deps.get`. Place your token in `config/token.exs` 
as below:

```elixir
# config/token.exs

config :nostrum,
  token: "<bot token>"
```

You may now run the bot with `iex -S mix`.

