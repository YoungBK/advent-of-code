defmodule AdventOfCode.Fuel do
  def calc(weight), do: Integer.floor_div(weight, 3) - 2

  def exec(file) do
    File.read!(file)
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
    |> Enum.map(&calc/1)
    |> Enum.sum()
  end
end
