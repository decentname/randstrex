defmodule Randstrex do
  @moduledoc """
  Documentation for `Randstrex`.
  """

  alias Randstrex.Generator
  alias Randstrex.RegexpParser

  @doc """
  Generate n random strings from regex

  ## Examples

      iex> Randstrex.generate(/[-+]?[0-9]{1,16}[.][0-9]{1,6}/, 10)
      {:ok, ["-1752643936.096896",
      "9519688.31",
      "+1.7036",
      "+65048.3876",
      "-6547028036936294.111",
      "07252345.650",
      "-27557.78",
      "7385289878518.439775",
      "13981103761187.90",
      "4100273498885.614"]}
  """
  def generate(regex, n) do
    regex |> String.slice(1..-2) |> RegexpParser.parse_regex() |> Generator.generate_strings(n)
  end
end
