defmodule AdventOfCode202019.A do
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
0: 4 1 5
1: 2 3 | 3 2
2: 4 4 | 5 5
3: 4 5 | 5 4
4: "a"
5: "b"

ababbb
bababa
abbbab
aaabbb
aaaabbb
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

  # Parse as list of lists of ???
  # Parse as map of ?
  # Parse as map of maps of ?
  def grab_until_break([first|rest], acc \\ []) do
    case first do
      "" -> { Enum.reverse(acc), rest }
      _  -> grab_until_break(rest, [first|acc])
    end
  end

  def split_alternates([idx, rule]), do: [idx, rule |> String.split("|") |> Enum.map(&String.trim/1)]
  def split_rule_parts([idx, [_|_] = rules]), do: [idx, Enum.map(rules, &String.split(&1, " "))]

  def parse_rule_line(line) do
    line
    |> String.split(":")
    |> Enum.map(&String.trim/1)
    |> split_alternates()
    |> split_rule_parts()
  end

  def compare(map1, map2) do
    Map.keys(map1) -- Map.keys(map2) == [] &&
      Map.keys(map2) -- Map.keys(map1) == [] &&
      Enum.all?(Map.keys(map1), fn k -> Map.get(map1, k, []) -- Map.get(map2, k, []) == [] &&
                                        Map.get(map2, k, []) -- Map.get(map1, k, []) == [] end)
  end
  
  def resolve_rule(rulemap, {idx,rules}, acc) do
    # IO.inspect(idx, label: "resolve_rule idx")
    # IO.inspect(rules, label: "resolve_rule rules")
    # IO.inspect(acc, label: "resolve_rule acc")
    Map.put(acc, idx, rules |> Enum.reduce([], fn r,a -> expand_rule(rulemap, r) ++ a end))
  end
  def expand_rule(_rulemap, []), do: [[]]
  def expand_rule(rulemap, ["a"] = rule), do: [rule]
  def expand_rule(rulemap, ["b"] = rule), do: [rule]
  def expand_rule(rulemap, [first|rest]) do
    # IO.inspect(first, label: "expand_rule first")
    # IO.inspect(rest, label: "expand_rule rest")
    first_alts = case first do
                   "a" -> [["a"]]
                   "b" -> [["b"]]
                   other -> Map.get(rulemap, first)
                 end
                 # |> IO.inspect(label: "expand_rule mapget first_alts")
    expand_rule(rulemap, rest) # |> IO.inspect(label: "expand_rule expand_rule rest result")
    |> Enum.reduce([], fn rr,acc -> Enum.map(first_alts, fn fa -> fa ++ rr end) ++ acc end) # |> IO.inspect(label: "expand_rule map map result")
  end

  def resolve_rules(rulemap), do: Enum.reduce(rulemap, %{}, &resolve_rule(rulemap, &1, &2))
  def resolve_rules_loop(rulemap) do
    resolved = resolve_rules(rulemap) # |> IO.inspect(label: "resolve_rules_loop resolved")
    # IO.inspect(rulemap, label: "resolve_rules_loop rulemap")
    if compare(resolved,rulemap), do: resolved, else: resolve_rules_loop(resolved)
  end
  def convert([["\"a\""]]), do: [["a"]]
  def convert([["\"b\""]]), do: [["b"]]
  def convert(other), do: other

  def parse_rules({rule_lines, data}), do: {parse_rules(rule_lines), data}
  def parse_rules([_|_] = list) do
    list
    |> Enum.map(&parse_rule_line/1) # |> IO.inspect(label: "parse_rules parse_rule_line map result")
    |> Enum.reduce(%{}, fn [k,v],acc -> Map.put(acc, k, convert(v)) end) # |> IO.inspect(label: "parse_rules reduce result")
    |> resolve_rules_loop() #|> IO.inspect(label: "parse_rules resolve_rules result")
  end

  def check_existence({map, values}) do
    valid_list = Map.get(map, "0")
    |> Enum.map(fn chars -> Enum.join(chars) end)

    Enum.filter(values, fn v -> v in valid_list end)
  end

  def exec(list) do
    list
    |> grab_until_break()
    |> parse_rules()
    |> check_existence()
    |> Enum.count()
#    |> apply_rules()
#    |> Enum.sum()
#    |> count_occupied()
  end
end




