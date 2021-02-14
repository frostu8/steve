defmodule Steve.Voice do
  alias Nostrum.Voice

  def play_audio(guild_id) do
    if Voice.ready?(guild_id) and not Voice.playing?(guild_id) do
      :ok = Voice.play(guild_id, "sex.mp3", :url)
    else
      play_audio(guild_id)
    end
  end

  def get_user_voice_channel(guild_id, user_id) do
    guild_id
    |> Nostrum.Cache.GuildCache.get!()
    |> Map.get(:voice_states)
    |> Enum.find(%{}, fn v -> v.user_id == user_id end)
    |> Map.get(:channel_id)
  end
end
