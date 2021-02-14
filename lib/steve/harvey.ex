defmodule Steve.Harvey do
  @prefix "steve!"

  use Nostrum.Consumer

  alias Nostrum.Api
  alias Nostrum.Cache.GuildCache
  alias Nostrum.Voice

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    # verify we are in a guild
    if msg.guild_id do 
      # and we are reading a commandj
      if String.starts_with?(msg.content, @prefix) do
        # and the user has permissions
        if Steve.Util.is_administrator(Map.merge(msg.member, %{user: msg.author}), msg.guild_id) do
          handle_command(msg, String.slice(msg.content, String.length(@prefix)..-1));
        end
      end
    end
  end

  def handle_event({:VOICE_SPEAKING_UPDATE, voice, _ws_state}) do
    if !voice.speaking do
      # play steve harvey
      play_steve_harvey(voice.guild_id)
    end
  end

  def handle_event(_event) do
    :noop
  end

  def play_steve_harvey(guild_id) do
    if Voice.ready?(guild_id) do
      :ok = Voice.play(guild_id, "sex.mp3", :url)
    else
      play_steve_harvey(guild_id)
    end
  end

  def get_voice_channel_of_msg(guild_id, user_id) do
    guild_id
    |> GuildCache.get!()
    |> Map.get(:voice_states)
    |> Enum.find(%{}, fn v -> v.user_id == user_id end)
    |> Map.get(:channel_id)
  end

  def handle_command(msg, command) do
    case command do
      "join" ->
        # attempt to join
        case get_voice_channel_of_msg(msg.guild_id, msg.author.id) do
          nil ->
            Api.create_message(msg.channel_id, "You must be in a voice channel to summon Steve Harvey.")
          voice_channel_id ->
            Voice.join_channel(msg.guild_id, voice_channel_id)
            play_steve_harvey(msg.guild_id)
        end
      "leave" ->
        # attempt to leave
        Voice.leave_channel(msg.guild_id)
    end
  end
end
