defmodule AdventOfCode202016.A do
  use Bitwise
  
  def read_data() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split(~r/[\n]/)
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
""" |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn s -> String.split(s, ",") end)
    |> List.flatten()
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

  def reduce(startv, endv, hash) do
    Enum.reduce((startv..endv), hash, fn n,h -> Map.put(h, n, true) end)
  end
  
  def add_to_valid_field_numbers(hash, [r1start, r1end, r2start, r2end]) do
    reduce(r1start, r1end, reduce(r2start, r2end, hash))
  end
  
  def parse_field(string) do
    IO.inspect(string, label: "parse_field")
    [field, numbers] = String.split(string, ": ")
    String.split(numbers, ~r/-| or /) |> Enum.map(&String.to_integer/1)
  end
  def parse_fields([first|rest] = list, valid_field_numbers \\ %{}) do
    cond do
      first == "your ticket:" -> {tl(tl(rest)), valid_field_numbers}
      first == "" -> parse_fields(rest, valid_field_numbers)
      true -> parse_fields(rest, add_to_valid_field_numbers(valid_field_numbers, parse_field(first)))
    end
  end

  def find_invalid_values({["nearby tickets:"|list], valid_values}, acc \\ []) do
    find_invalid_values(list, valid_values, acc)
  end
  def find_invalid_values([], valid_values, acc), do: acc
  def find_invalid_values([first|rest], valid_values, acc) do
    IO.inspect(first, label: "find_invalid_values")
    find_invalid_values(
      rest,
      valid_values,
      acc ++ (String.split(first, ",") |> Enum.map(&String.to_integer/1) |> Enum.reject(fn n -> valid_values[n] == true end))
    )
  end
  
  def exec(list) do
    list
    |> parse_fields()
    |> find_invalid_values()
    |> Enum.sum()
  end
end

