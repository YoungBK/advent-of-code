defmodule AdventOfCode202015.A do
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
  def calc_number(history, index) do
    case Map.get(history.by_value, Map.get(history.by_index, index - 1), nil) do
      nil -> 0
      [num] -> 0
      [num,prior|rest] -> num - prior
    end
  end

  def add_next_number_to_index(history, index) do
    value = calc_number(history, index) # |> IO.inspect(label: "value")
    Map.put(history, :by_index, Map.put(history.by_index, index, value))
    |> Map.put(:by_value, Map.put(history.by_value, value, [index|Map.get(history.by_value, value, [])]))
    # |> IO.inspect(label: "add_next_number_to_index")
  end
  
  def find_value(history, index, top) do
    cond do
      index == top -> history
      true -> find_value(add_next_number_to_index(history, index), index + 1, top)
    end
  end

  def build_history([], index, acc), do: acc
  def build_history([first|rest], index \\ 0, acc \\ %{by_index: %{}, by_value: %{}}) do
    build_history(rest, index + 1,
      Map.put(acc, :by_index, Map.put(acc.by_index, index, first))
      |> Map.put(:by_value, Map.put(acc.by_value, first, [index | Map.get(acc.by_value, first, [])])))
  end
  
  def exec(list) do
    list
    |> IO.inspect(label: "list")
    |> build_history()
    |> IO.inspect(label: "build_history")
    |> find_value(6, 2020)
    |> IO.inspect(label: "map")
    |> Map.get(:by_index)
    |> Map.get(2019)
  end
end

