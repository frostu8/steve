defmodule Steve.Util do
  use Bitwise

  alias Nostrum.Cache.GuildCache

  def is_administrator(member, guild_id) do
    member
    |> Nostrum.Struct.Guild.Member.guild_permissions(GuildCache.get!(guild_id))
    |> Enum.any?(fn p -> p === :administrator end)
  end
end
