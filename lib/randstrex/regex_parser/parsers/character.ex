defmodule Randstrex.RegexpParser.Character do
  @moduledoc "Parse a literal character."

  use Combine
  use Combine.Helpers
  alias Randstrex.RegexpParser.Quantifier
  alias __MODULE__, as: M

  @enforce_keys [:char]
  defstruct [:char, :quantifier]

  def parser_character do
    map(
      sequence([
        char(),
        Quantifier.parser_quantifier()
      ]),
      fn
        [c, q] -> %M{char: c, quantifier: q}
        [c] -> %M{char: c}
      end
    )
  end
end
