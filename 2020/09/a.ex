defmodule AdventOfCode202009.A do
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

  def create_list([first|rest], count, acc \\ []) do
    cond do
      count == 0 -> {Enum.reverse(acc), [first|rest]}
      true -> create_list(rest, count - 1, [first|acc])
    end
  end

  def exists_pair?(list, element) do
    Enum.any?(list, fn el -> Enum.find(list, fn x -> x == element - el end) end)
  end
  
  def find_wrong({list, [first|rest]}) do
    case exists_pair?(list, first) do
      true -> find_wrong({tl(list) ++ [first], rest})
      false -> first
    end
  end
  
  def exec(list) do
    list
    |> create_list(25)
    |> find_wrong()
  end
end
