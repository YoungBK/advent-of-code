defmodule AdventOfCode202015.B do
  use Bitwise
  
  def read_data() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split(~r/[\n]/)
    |> Enum.map(&String.to_integer/1)
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
"""
0,3,6
""" |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn s -> String.split(s, ",") end)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
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
  def calc_next_number(history) do
    case Map.get(history.by_value, history.last, nil) do
      nil -> 0
      [num] -> 0
      [num,prior|rest] -> num - prior
    end
  end

  def add_next_number_to_index(history, index) do
    value = calc_next_number(history) # |> IO.inspect(label: "value")
    Map.put(history, :last, value)
    |> Map.put(:by_value, Map.put(history.by_value, value, [index | Map.get(history.by_value, value, [])]))
    # |> IO.inspect(label: "add_next_number_to_index")
  end
  
  def find_value(history, index, top) do
    if rem(index, 10000000) == 0 do
      IO.inspect(index, label: "build_history index")
      IO.puts(Time.utc_now())
    end
    cond do
      index == top -> history
      true -> find_value(add_next_number_to_index(history, index), index + 1, top)
    end
  end

  def build_history([], index, acc), do: acc
  def build_history([first|rest], index \\ 0, acc \\ %{last: nil, by_value: %{}}) do
    build_history(rest, index + 1,
      Map.put(acc, :last, first)
      |> Map.put(:by_value, Map.put(acc.by_value, first, [index | Map.get(acc.by_value, first, [])])))
  end
  
  def exec(list, limit) do
    list
    |> IO.inspect(label: "list")
    |> build_history()
    |> IO.inspect(label: "build_history")
    |> find_value(6, limit + 1)
    |> IO.inspect(label: "map")
    |> Map.get(:last)
  end
end


# a b c 
# 0 1 2
