defmodule AdventOfCode.Fuel do
  def calc(weight), do: Integer.floor_div(weight, 3) - 2
  def calc(weight, list) do
    fuel = calc(weight)
    if fuel > 0, do: calc(fuel, [fuel | list]), else: list
  end

  def exec(file) do
    File.read!(file)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&calc(&1, []))
    |> List.flatten()
    |> Enum.sum()
  end
end
