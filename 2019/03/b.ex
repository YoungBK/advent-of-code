defmodule AdventOfCode.Wires do
  def run_to_points({x,y,d}, "R" <> lenstr) do
    len = String.to_integer(lenstr)
    {{x + len, y, d + len}, Enum.map(1..len, fn l -> {x + l, y, d + l} end)}
  end
  def run_to_points({x,y,d}, "L" <> lenstr) do
    len = String.to_integer(lenstr)
    {{x - len, y, d + len}, Enum.map(1..len, fn l -> {x - l, y, d + l} end)}
  end
  def run_to_points({x,y,d}, "U" <> lenstr) do
    len = String.to_integer(lenstr)
    {{x, y + len, d + len}, Enum.map(1..len, fn l -> {x, y + l, d + l} end)}
  end
  def run_to_points({x,y,d}, "D" <> lenstr) do
    len = String.to_integer(lenstr)
    {{x, y - len, d + len}, Enum.map(1..len, fn l -> {x, y - l, d + l} end)}
  end

  def convert_runs([], _start, points), do: points
  def convert_runs([head|rest], start, points) do
    {newstart, newpoints} = run_to_points(start, head)
    convert_runs(rest, newstart, points ++ newpoints)
  end

  def gen_runs(runs) do
    runs |> Enum.map(&convert_runs(&1, {0,0,0}, []))
  end

  def accumulate({x,y,d}, acc) do
    case acc[{x,y}] do
      nil -> Map.put(acc, {x,y}, {x,y,d})
      {^x,^y,d2} -> %{acc | {x,y} => {x,y,min(d,d2)}}
    end
  end

  def intersect_lists(first, second), do: first -- (first -- second)

  def calc_distance({_x1, _y1, d1}, {_x2, _y2, d2}), do: d1 + d2

  def path_to_map(path), do: Enum.reduce(path, %{}, &accumulate/2)

  def find_minimum_intersection_distance([path1,path2]) do
    find_minimum_intersection_distance(path_to_map(path1), path_to_map(path2))
  end
  def find_minimum_intersection_distance(pathmap1, pathmap2) do
    intersect_lists(Map.keys(pathmap1), Map.keys(pathmap2))
    |> Enum.map(fn k -> calc_distance(pathmap1[k], pathmap2[k]) end)
    |> Enum.sort()
    |> hd()
  end

  def read_data() do
    File.read!("data.txt")
    |> String.trim()
    |> String.split()
    |> Enum.map(&String.split(&1, ","))
  end

  def exec() do
    read_data()
    |> gen_runs()
    |> find_minimum_intersection_distance()
  end
end
