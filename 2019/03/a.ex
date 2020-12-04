defmodule AdventOfCode.Wires do
  def run_to_points({x,y}, "R" <> lenstr) do
    len = String.to_integer(lenstr)
    {{x + len, y}, Enum.map(1..len, fn l -> {x + l, y} end)}
  end
  def run_to_points({x,y}, "L" <> lenstr) do
    len = String.to_integer(lenstr)
    {{x - len, y}, Enum.map(1..len, fn l -> {x - l, y} end)}
  end
  def run_to_points({x,y}, "U" <> lenstr) do
    len = String.to_integer(lenstr)
    {{x, y + len}, Enum.map(1..len, fn l -> {x, y + l} end)}
  end
  def run_to_points({x,y}, "D" <> lenstr) do
    len = String.to_integer(lenstr)
    {{x, y - len}, Enum.map(1..len, fn l -> {x, y - l} end)}
  end

  def convert_runs([], _start, points), do: points
  def convert_runs([head|rest], start, points) do
    {newstart, newpoints} = run_to_points(start, head)
    convert_runs(rest, newstart, points ++ newpoints)
  end

  def gen_runs(runs) do
    runs |> Enum.map(&convert_runs(&1, {0,0}, []))
  end

  def intersection([first,second]) do
    first -- (first -- second)
  end

  def read_data() do
    File.read!("data.txt")
    |> String.trim()
    |> String.split()
    |> Enum.map(&String.split(&1, ","))
  end

  def calc_dist({x1, y1}, {x2, y2}), do: abs(x1 - x2) + abs(y1 - y2)

  def exec() do
    read_data()
    |> gen_runs()
    |> intersection()
    |> Enum.map(&calc_dist(&1, {0,0}))
    |> Enum.min()
  end
end
