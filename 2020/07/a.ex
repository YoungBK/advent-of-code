defmodule AdventOfCode202007.A do
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
light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
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

  def parse_info_contains(str) do
    case String.starts_with?(str, "no") do
      true ->
        {}
      _ ->
        [countstr | info] = String.split(str, " ")
        {Enum.join(info, " "), String.to_integer(countstr)}
    end
  end

  def to_info_map(list) do
    Enum.reduce(list, %{}, fn {k,v},acc -> Map.put(acc, k, v)
                              {}, acc -> acc end)
  end

  def parse_info(str) do
    case String.starts_with?(str, "no") do
      true -> str
      _ ->
        [_countstr | info] = String.split(str, " ")
        Enum.join(info, " ")
    end
  end

  def add_key_val(map, key, val) do
    case Map.get(map, key) do
      nil  -> Map.put(map, key, [val])
      list -> Map.put(map, key, [val|list])
    end
  end

  def make_mapping(map, [val|rest]) do
    Enum.map(rest, &parse_info/1)
    |> Enum.reduce(map, &add_key_val(&2, &1, val))
  end

  def parse_line(line) do
    String.split(line, ~r/bags contain | bags, | bag, | bags\.| bag\./)
    |> Enum.reject(fn s -> s == "" end)
    |> Enum.map(&String.trim/1)
  end

  def count_chains(contained_in, color, acc \\ []) do
    case Map.get(contained_in, color) do
      nil  -> acc
      list -> Enum.reduce(list, acc ++ list, &count_chains(contained_in, &1, &2))
    end
  end

  def exec(list, color) do
    list
    |> Enum.map(&parse_line/1)
    |> Enum.reduce(%{}, &make_mapping(&2,&1))
    |> count_chains(color)
    |> Enum.uniq()
    |> Enum.count
  end
end
