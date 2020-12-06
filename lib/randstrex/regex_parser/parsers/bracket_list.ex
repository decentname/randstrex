defmodule Randstrex.RegexpParser.BracketList do
  @moduledoc "Parse a list, like [abc] or [^abc]."

  use Combine
  use Combine.Helpers
  alias Randstrex.RegexpParser.Quantifier
  alias __MODULE__, as: M

  @enforce_keys [:except, :characters, :ranges, :quantifier]
  defstruct [:except, :characters, :ranges, :quantifier]

  def parser_list do
    map(
      pair_both(
        list(),
        Quantifier.parser_quantifier()
      ),
      fn {[e, [r], c], q} ->
        %M{except: e, ranges: r, characters: c, quantifier: q}
      end
    )
  end

  def list do
    sequence([
      ignore(char("[")),
      map(option(char("^")), &(&1 == "^")),
      map(option(sequence([alphanumeric(), char("-"), alphanumeric()])), &[&1]),
      many(satisfy(char(), &(&1 != "]"))),
      ignore(char("]"))
    ])
  end
end
