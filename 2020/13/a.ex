defmodule AdventOfCode202013.A do
  def read_data() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split(~r/[\n]/)
  end

  def read_csv() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split("\n")
  end

  def read_groups() do
    read_data() |> group()
  end
  
  def test_data() do
"""
""" |> String.trim()
    |> String.split(~r/[\n]/)
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

  def calc_info([first,second]) do
    second
    |> String.split(",")
    |> Enum.reject(fn el -> el == "x" end)
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(fn bus -> {bus, bus - rem(String.to_integer(first), bus)} end)
    |> Enum.sort(fn {bus1,wait1}, {bus2,wait2} -> wait1 <= wait2 end)
    |> hd()
  end
  
  def exec(list) do
    {bus, wait} = list
    |> calc_info()

    bus * wait
  end
end
