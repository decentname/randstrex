defmodule Randstrex.Generator do
  @moduledoc """
  Documentation for Randstrex Generator.
  """

  alias Randstrex.RegexpParser.BracketList
  alias Randstrex.RegexpParser.Character
  alias Randstrex.RegexpParser.Dot
  alias Randstrex.RegexpParser.Quantifier

  @range 32..126

  def generate_strings({:ok, resp}, n) do
    {:ok, Enum.reduce(1..n, [], fn _x, acc -> [Enum.reduce(resp, "", &generate/2) | acc] end)}
  end

  def generate_strings({:error, error}, _n), do: {:error, error}

  defp generate(%Character{char: char, quantifier: nil}, acc), do: acc <> char

  defp generate(%Character{char: char, quantifier: %Quantifier{max: max, min: min}}, acc) do
    acc <> String.duplicate(char, Enum.random(min..max))
  end

  defp generate(%Dot{quantifier: nil}, acc), do: acc <> "."

  defp generate(%Dot{quantifier: %Quantifier{max: max, min: min}}, acc) do
    acc <> String.duplicate(".", Enum.random(min..max))
  end

  defp generate(
         %BracketList{
           quantifier: %Quantifier{max: max, min: min},
           except: true,
           characters: characters,
           ranges: nil
         },
         acc
       ) do
    r =
      characters
      |> reject_chars
      |> Enum.take_random(Enum.random(min..max))

    acc <> r
  end

  defp generate(
         %BracketList{quantifier: :__ignore, except: true, characters: characters, ranges: nil},
         acc
       ) do
    r =
      characters
      |> reject_chars
      |> Enum.random()

    acc <> r
  end

  defp generate(
         %BracketList{
           quantifier: :__ignore,
           characters: _characters,
           except: true,
           ranges: ranges
         },
         acc
       ) do
    r =
      ranges
      |> reject_ranges
      |> Enum.random()

    acc <> to_string([r])
  end

  defp generate(
         %BracketList{
           quantifier: %Quantifier{max: max, min: min},
           characters: _characters,
           ranges: ranges,
           except: true
         },
         acc
       ) do
    r =
      ranges
      |> reject_ranges
      |> Enum.take_random(Enum.random(min..max))
      |> to_string

    acc <> r
  end

  defp generate(
         %BracketList{
           quantifier: %Quantifier{max: max, min: min},
           characters: characters,
           ranges: nil
         },
         acc
       ) do
    r = characters |> Enum.take_random(Enum.random(min..max)) |> to_string
    acc <> r
  end

  defp generate(%BracketList{quantifier: :__ignore, characters: characters, ranges: nil}, acc) do
    acc <> Enum.random(characters)
  end

  defp generate(%BracketList{quantifier: :__ignore, characters: _characters, ranges: ranges}, acc) do
    [<<head::utf8>> | _] = ranges
    <<tail::utf8>> = List.last(ranges)
    ascii = Enum.random(head..tail)
    acc <> to_string([ascii])
  end

  defp generate(
         %BracketList{
           quantifier: %Quantifier{max: max, min: min},
           characters: _characters,
           ranges: ranges
         },
         acc
       ) do
    [<<head::utf8>> | _] = ranges
    <<tail::utf8>> = List.last(ranges)
    r = head..tail |> Enum.take_random(Enum.random(min..max)) |> to_string
    acc <> r
  end

  defp generate(_, acc) do
    acc
  end

  defp reject_chars(characters) do
    preset = @range |> Enum.reduce([], fn x, acc -> [x | acc] end) |> to_string

    characters
    |> Enum.reduce(preset, fn c, p -> String.replace(p, c, "") end)
    |> String.split("")
  end

  defp reject_ranges(ranges) do
    [<<head::utf8>> | _] = ranges
    <<tail::utf8>> = List.last(ranges)

    @range
    |> Enum.reduce([], fn x, acc -> [x | acc] end)
    |> Enum.reject(fn x -> x <= tail && x >= head end)
  end
end
