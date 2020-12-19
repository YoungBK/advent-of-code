defmodule AdventOfCode202018.A do
  use Bitwise
  
  def read_data() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split(~r/[\n]/)
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&Enum.reject(&1, fn v -> v == " " end))
    |> Enum.map(&Enum.map(&1, fn v -> if String.match?(v, ~r/^[[:digit:]]+$/), do: String.to_integer(v), else: v end))
  end

  def read_csv() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn s -> String.split(s, ",") end)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
  end

  def read_groups() do
    read_data() |> group()
  end
  
  def test_data() do
    # 51 600
# 1 + (2 * 3) + (4 * (5 + 6)) -> 51
# (4 + 7 * 6 * 5) -> 330
# (4 + (4 + 7 * 6 * 5) + 6) -> 340
# (4 + (4 + 7 * 6 * 5) + 6) + (3 * 2 + 2) + 3 + (8 * 5 * 6) + 9 -> 600
# 6 * ((5 * 3 * 2 + 9 * 4) * (8 * 8 + 2 * 3) * 5 * 8) * 2 + (4 + 9 * 5 * 5 + 8) * 4
# (2 + 4 * 9) * (6 + 9 * 8 + 6) + 6 -> 6810 but gives 7128
    
"""
(2 + 4 * 9) * (6 + 9 * 8 + 6) + 6
((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6)
((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6)
((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2
""" |> String.trim()
    |> String.split(~r/[\n]/)
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&Enum.reject(&1, fn v -> v == " " end))
    |> Enum.map(&Enum.map(&1, fn v -> if String.match?(v, ~r/^[[:digit:]]+$/), do: String.to_integer(v), else: v end))
  end

  def add_to_group(list, group \\ [])
  def add_to_group([], group), do: {group, nil}
  def add_to_group([answers | rest], group) do
    case answers do
      "" ->
        {group, rest}
      _  ->
        add_to_group(rest, [answers | group])
    end
  end

  def group(list, retlist \\ []) do
    {group, rest} = add_to_group(list)
    case rest do
      nil -> [group | retlist]
      _ -> group(rest, [group | retlist])
    end
  end

  # Parse as list of lists of ???
  # Parse as map of ?
  # Parse as map of maps of ?
  def match_parens(list, -1, [")"|acc]), do: {Enum.reverse(acc), list}
  def match_parens(list, -1, _), do: raise "This is broken"
  def match_parens([first|rest], depth \\ 0, acc \\ []) do
    case first do
      "(" -> match_parens(rest, depth + 1, [first|acc])
      ")" -> match_parens(rest, depth - 1, [first|acc])
      char -> match_parens(rest, depth, [char|acc])
    end
  end
  def evaluate([x]) when is_integer(x), do: x
  def evaluate([x, "*", y|rest]) when is_integer(x) and is_integer(y), do: evaluate([x * y |rest])
  def evaluate([x, "+", y|rest]) when is_integer(x) and is_integer(y), do: evaluate([x + y |rest])
  def evaluate([x, op, "("|rest]) when is_integer(x) do
    {list, remainder} = match_parens(rest)
    case op do
      "*" -> evaluate([x * evaluate(list)|remainder])
      "+" -> evaluate([x + evaluate(list)|remainder])
    end
  end
  def evaluate(["("|rest]) do
    {list, remainder} = match_parens(rest)
    case remainder do
      ["*"|rem_rest] -> evaluate([evaluate(list), "*"|rem_rest])
      ["+"|rem_rest] -> evaluate([evaluate(list), "+"|rem_rest])
      [] -> evaluate(list)
    end
  end
  
  def exec(list) do
    list
    |> Enum.map(&evaluate/1)
#    |> Enum.sum()
#    |> count_occupied()
  end
end




