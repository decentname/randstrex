defmodule Randstrex.RegexpParser do
  @moduledoc """
  Documentation for `Randstrex.RegexpParser`.
  """

  use Combine

  alias Randstrex.RegexpParser.BracketList
  alias Randstrex.RegexpParser.Character
  alias Randstrex.RegexpParser.Dot

  def parse_regex(nil), do: {:ok, nil}

  def parse_regex(regex) when is_binary(regex) do
    [p] =
      Combine.parse(
        regex,
        many(
          choice([
            BracketList.parser_list(),
            Dot.parser_dot(),
            Character.parser_character()
          ])
        )
      )

    {:ok, p}
  end

  def parse_regex(_regex) do
    {:error, "Not a valid Expression"}
  end
end
