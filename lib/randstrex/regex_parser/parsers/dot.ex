defmodule Randstrex.RegexpParser.Dot do
  @moduledoc "Parse a dot metacharacter."

  use Combine
  use Combine.Helpers
  import Randstrex.RegexpParser.Quantifier
  alias __MODULE__, as: M

  defstruct [:quantifier]

  def parser_dot do
    map(
      sequence([
        ignore(char(".")),
        parser_quantifier()
      ]),
      fn
        [q] -> %M{quantifier: q}
        [] -> %M{}
      end
    )
  end
end
