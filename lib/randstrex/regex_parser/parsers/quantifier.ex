defmodule Randstrex.RegexpParser.Quantifier do
  @moduledoc "Parse a quantifier. A quantifier is a optional +, *, ? or {n,m}."

  use Combine
  use Combine.Helpers
  alias Combine.ParserState
  alias __MODULE__, as: M

  @enforce_keys [:min]
  defstruct [:min, :max]

  def parser_quantifier do
    choice([
      parser_braces_full(),
      parser_braces_at_least(),
      parser_braces_exactly(),
      quantifier_abbreviation()
    ])
  end

  # Parser for explit quantifier
  # {n,m}
  def parser_braces_full do
    pipe(
      [
        char("{"),
        integer(),
        char(","),
        integer(),
        char("}")
      ],
      fn [_, min, _, max, _] -> %M{min: min, max: max} end
    )
  end

  # {n,}
  def parser_braces_at_least do
    pipe(
      [
        char("{"),
        integer(),
        char(","),
        char("}")
      ],
      fn [_, min, _, _] -> %M{min: min} end
    )
  end

  # {n}
  def parser_braces_exactly do
    pipe(
      [
        char("{"),
        integer(),
        char("}")
      ],
      fn [_, value, _] -> %M{min: value, max: value} end
    )
  end

  # Parse for +, * and ?
  @metacharacters [?*, ?+, ??]

  defparser quantifier_abbreviation(
              %ParserState{
                status: :ok,
                column: col,
                input: <<c::utf8, rest::binary>>,
                results: results
              } = state
            )
            when c in @metacharacters do
    character =
      case c do
        ?* -> %M{min: 0}
        ?+ -> %M{min: 1}
        ?? -> %M{min: 0, max: 1}
      end

    %{state | :column => col + 1, :input => rest, :results => [character | results]}
  end

  defp quantifier_abbreviation_impl(%ParserState{status: :ok} = state) do
    state
  end
end
