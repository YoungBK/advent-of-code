defmodule AdventOfCode202017.A do
  use Bitwise
  
  def read_data() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split(~r/[\n]/)
    |> Enum.map(&String.graphemes/1)
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
""" |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.graphemes/1)
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
  def create_elements(result, [], _, _), do: result
  def create_elements(result, [head|rest], row, col) do
    Map.put(result, {row,col,0}, head)
    |> create_elements(rest, row, col + 1)
  end

  def create_map(result, [], _), do: result
  def create_map(result, [first|rest], row) do
    create_elements(result, first, row, 0) |> create_map(rest, row + 1)
  end

  def neighbors_of(state, {r,c,z}) do
    [{r-1, c-1, z-1}, {r-1, c, z-1}, {r-1, c+1, z-1},
     {r, c-1, z-1},   {r, c, z-1},   {r, c+1, z-1},
     {r+1, c-1, z-1}, {r+1, c, z-1}, {r+1, c+1, z-1},

     {r-1, c-1, z}, {r-1, c, z}, {r-1, c+1, z},
     {r, c-1, z}, {r, c+1, z},
     {r+1, c-1, z}, {r+1, c, z}, {r+1, c+1, z},
     
     {r-1, c-1, z+1}, {r-1, c, z+1}, {r-1, c+1, z+1},
     {r, c-1, z+1},   {r, c, z+1},   {r, c+1, z+1},
     {r+1, c-1, z+1}, {r+1, c, z+1}, {r+1, c+1, z+1}]
  end

  def new_state(state, {pos,v}) do
    neighbor_count = neighbors_of(state, pos) |> Enum.count(fn val -> val == "#" end)
    cond do
      neighbor_count == 3 -> "#"
      v == "#" && neighbor_count == 2 -> "#"
      true -> "."
    end
  end
  
  def step_orig(state) do
    Enum.reduce(state, %{}, fn {k,v}, acc -> Map.put(acc, k, new_state(state, {k,v})) end)
  end

  def neighbor_counts(state, {pos, "#"}, cells_to_check) do
    Enum.reduce(neighbors_of(state, pos), cells_to_check,
      fn pos,a -> Map.put(a, pos, Map.get(a, pos, 0) + 1) end)
  end
  def neighbor_counts(state, _, cells_to_check), do: cells_to_check

  def cells_to_check(state), do: Enum.reduce(state, %{}, &neighbor_counts(state, &1, &2))

  def live_or_dead(state, {pos, count}, acc) do
    cond do
      count == 3 -> Map.put(acc, pos, "#")
      Map.get(state, pos, ".") == "#" && count == 2 -> Map.put(acc, pos, "#")
      true -> acc
    end
  end

  def step(state) do
    cells_to_check(state)
    |> Enum.reduce(%{}, &live_or_dead(state, &1, &2))
  end
  
  def equal(state, next) do
    Enum.count(state) == Enum.count(next) &&
      Enum.all?(state, fn {k,v} -> Map.get(next, k, nil) == v end)
  end

  def step_for_count(state, 0), do: state
  def step_for_count(state, count), do: step_for_count(step(state), count - 1)

  def count_occupied(state) do
    Enum.count(state, fn {_k,v} -> v == "#" end)
  end

  def exec(list) do
    create_map(%{}, list, 0) |> IO.inspect(label: "structure")
    |> step_for_count(6)
    |> count_occupied()
  end
end

