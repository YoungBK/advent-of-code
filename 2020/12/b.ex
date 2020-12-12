defmodule AdventOfCode202012.B do
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

  def split_instruction("N" <> dirval), do: {:N, String.to_integer(dirval)}
  def split_instruction("E" <> dirval), do: {:E, String.to_integer(dirval)}
  def split_instruction("W" <> dirval), do: {:W, String.to_integer(dirval)}
  def split_instruction("S" <> dirval), do: {:S, String.to_integer(dirval)}
  def split_instruction("R" <> dirval), do: {:R, String.to_integer(dirval)}
  def split_instruction("L" <> dirval), do: {:L, String.to_integer(dirval)}
  def split_instruction("F" <> dirval), do: {:F, String.to_integer(dirval)}

  @dirs [:N, :S, :E, :W, :R, :L]
  def apply_instruction({dir, amt}, {location, way1, way2}) when dir in @dirs do
    {location, adjust({dir, amt}, way1), adjust({dir,amt}, way2)}
  end
  def apply_instruction({:F, amt}, {location, way1, way2}) do
    { location |> move(amt, way1) |> move(amt, way2), way1, way2 }
  end

  def adjust({dir, amt}, {dir, way_amt}) when dir in [:N,:S], do: {dir, amt + way_amt}
  def adjust({:S, amt}, {:N, way_amt}), do: {:N, way_amt - amt}
  def adjust({:N, amt}, {:S, way_amt}), do: {:S, way_amt - amt}
  def adjust({dir, amt}, {dir, way_amt}) when dir in [:E, :W], do: {dir , amt + way_amt}
  def adjust({:E, amt}, {:W, way_amt}), do: {:W, way_amt - amt}
  def adjust({:W, amt}, {:E, way_amt}), do: {:E, way_amt - amt}

  def adjust({:R, 90}, {:N, amt}), do: {:E, amt}
  def adjust({:R, 90}, {:S, amt}), do: {:W, amt}
  def adjust({:R, 90}, {:E, amt}), do: {:S, amt}
  def adjust({:R, 90}, {:W, amt}), do: {:N, amt}
  def adjust({:R, 180}, {:N, amt}), do: {:S, amt}
  def adjust({:R, 180}, {:S, amt}), do: {:N, amt}
  def adjust({:R, 180}, {:E, amt}), do: {:W, amt}
  def adjust({:R, 180}, {:W, amt}), do: {:E, amt}
  def adjust({:R, 270}, {:N, amt}), do: {:W, amt}
  def adjust({:R, 270}, {:S, amt}), do: {:E, amt}
  def adjust({:R, 270}, {:E, amt}), do: {:N, amt}
  def adjust({:R, 270}, {:W, amt}), do: {:S, amt}
  def adjust({:L, 90}, {dir, amt}), do: adjust({:R, 270}, {dir, amt})
  def adjust({:L, 180}, {dir, amt}), do: adjust({:R, 180}, {dir, amt})
  def adjust({:L, 270}, {dir, amt}), do: adjust({:R, 90}, {dir, amt})

  def adjust(_, waydir), do: waydir

  def move({x,y}, count, {:N, amt}), do: {x, y + count * amt}
  def move({x,y}, count, {:S, amt}), do: {x, y - count * amt}
  def move({x,y}, count, {:E, amt}), do: {x + count * amt, y}
  def move({x,y}, count, {:W, amt}), do: {x - count * amt, y}

  def calc_dist({{x,y}, _w1, _w2}), do: abs(x) + abs(y)
    
  def exec(list) do
    list
    |> Enum.map(&split_instruction/1)
    |> Enum.reduce({{0, 0}, {:E, 10}, {:N, 1}}, &apply_instruction/2)
    |> calc_dist()
  end
end

