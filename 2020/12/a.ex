defmodule AdventOfCode202012.A do
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

  def apply_instruction({:N, dirval}, {x,y,point}), do: {x,y+dirval,point}
  def apply_instruction({:S, dirval}, {x,y,point}), do: {x,y-dirval,point}
  def apply_instruction({:E, dirval}, {x,y,point}), do: {x+dirval,y,point}
  def apply_instruction({:W, dirval}, {x,y,point}), do: {x-dirval,y,point}
  def apply_instruction({:R, 90}, {x,y,:N}), do: {x,y,:E}
  def apply_instruction({:R, 90}, {x,y,:S}), do: {x,y,:W}
  def apply_instruction({:R, 90}, {x,y,:E}), do: {x,y,:S}
  def apply_instruction({:R, 90}, {x,y,:W}), do: {x,y,:N}
  def apply_instruction({:R, 180}, {x,y,:N}), do: {x,y,:S}
  def apply_instruction({:R, 180}, {x,y,:S}), do: {x,y,:N}
  def apply_instruction({:R, 180}, {x,y,:E}), do: {x,y,:W}
  def apply_instruction({:R, 180}, {x,y,:W}), do: {x,y,:E}
  def apply_instruction({:R, 270}, {x,y,:N}), do: {x,y,:W}
  def apply_instruction({:R, 270}, {x,y,:S}), do: {x,y,:E}
  def apply_instruction({:R, 270}, {x,y,:E}), do: {x,y,:N}
  def apply_instruction({:R, 270}, {x,y,:W}), do: {x,y,:S}
  def apply_instruction({:L, 90}, {x,y,point}), do: apply_instruction({:R, 270}, {x,y,point})
  def apply_instruction({:L, 180}, {x,y,point}), do: apply_instruction({:R, 180}, {x,y,point})
  def apply_instruction({:L, 270}, {x,y,point}), do: apply_instruction({:R, 90}, {x,y,point})
  def apply_instruction({:F, dirval}, {x,y,:N}), do: apply_instruction({:N, dirval}, {x,y,:N})
  def apply_instruction({:F, dirval}, {x,y,:S}), do: apply_instruction({:S, dirval}, {x,y,:S})
  def apply_instruction({:F, dirval}, {x,y,:E}), do: apply_instruction({:E, dirval}, {x,y,:E})
  def apply_instruction({:F, dirval}, {x,y,:W}), do: apply_instruction({:W, dirval}, {x,y,:W})

  def calc_dist({x,y,_dir}), do: abs(x) + abs(y)
    
  def exec(list) do
    list
    |> Enum.map(&split_instruction/1)
    |> Enum.reduce({0,0,:E}, &apply_instruction/2)
    |> calc_dist()
  end
end
