defmodule Steve.Harvey do
  @prefix "steve!"

  use Nostrum.Consumer

  alias Nostrum.Api
  alias Nostrum.Voice

  def start_link do
    Consumer.start_link(__MODULE__)
  end

  def handle_event({:MESSAGE_CREATE, msg, _ws_state}) do
    # verify we are in a guild
    if msg.guild_id do 
      member = Map.merge(msg.member, %{user: msg.author});

      # and we are reading a commandj
      if String.starts_with?(msg.content, @prefix) do
        # and the user has permissions
        if Steve.Util.is_administrator(member, msg.guild_id) do
          handle_command(msg, String.slice(msg.content, String.length(@prefix)..-1));
        end
      end
    end
  end

  def handle_event({:VOICE_SPEAKING_UPDATE, voice, _ws_state}) do
    if !voice.speaking do
      # play steve harvey
      Steve.Voice.play_audio(voice.guild_id)
    end
  end

  def handle_event(_event) do
    :noop
  end

  def handle_command(msg, command) do
    case command do
      "join" ->
        # attempt to join
        case Steve.Voice.get_user_voice_channel(msg.guild_id, msg.author.id) do
          nil ->
            Api.create_message(msg.channel_id, "You must be in a voice channel to summon Steve Harvey.")
          voice_channel_id ->
            Voice.join_channel(msg.guild_id, voice_channel_id)
            Steve.Voice.play_audio(msg.guild_id)
        end
      "leave" ->
        # attempt to leave
        Voice.leave_channel(msg.guild_id)
    end
  end
end
