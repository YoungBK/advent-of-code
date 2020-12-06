defmodule AdventOfCode202006.A do
  def read_data() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split(~r/[\n ]/)
  end

  def read_csv() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split("\n")
  end
  
  def test_data() do
"""    
""" |> String.trim()
    |> String.split(~r/[\n ]/)
  end

  def add_to_group(list, group \\ [])
  def add_to_group([], group), do: {group, nil}
  def add_to_group([answers | rest] = list, group) do
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

  def count_letters_in_list(list) do
    list
    |> Enum.reduce("", fn x,a -> a <> x end)
    |> String.graphemes()
    |> Enum.reduce(%{}, fn x,a -> Map.put(a, x, true) end)
    |> Map.keys()
    |> Enum.count()
  end
  
  def exec(list) do
    list
    |> group()
    |> Enum.map(&count_letters_in_list/1)
    |> Enum.sum()
#    |> Enum.count(&match_fun/1)
#    |> Enum.map(&convert_fun/1)
#    |> Enum.max()
#    |> Enum.min()
#    |> Enum.sort()
#    |> Enum.reduce(0, fn el, a -> end)
  end
end

# c "a.ex"
# alias AdventOfCode202006.A
# d = A.test_data()
# d = A.read_data()
# d = A.read_csv()
# A.exec(d)
