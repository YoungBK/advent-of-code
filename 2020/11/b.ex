defmodule AdventOfCode202011.B do
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
  end

  def read_groups() do
    read_data() |> group()
  end
  
  def test_data() do
"""
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
""" |> String.trim()
    |> String.split(~r/[\n]/)
    |> Enum.map(&String.graphemes/1)
  end

  def create_elements(result, [], _, _), do: result
  def create_elements(result, [head|rest], row, col) do
    Map.put(result, {row,col}, head)
    |> create_elements(rest, row, col + 1)
  end

  def create_map(result, [], _), do: result
  def create_map(result, [first|rest], row) do
    create_elements(result, first, row, 0) |> create_map(rest, row + 1)
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

  def get_neighbor(state, {r,c}, {rd,cd}) do
    neighbor = Map.get(state, {r+rd, c+cd}, nil)
    cond do
      neighbor == nil -> nil
      neighbor in ["#", "L"] -> neighbor
      true -> get_neighbor(state, {r+rd, c+cd}, {rd,cd})
    end
  end

  def neighbors_of(state, pos) do
    [{-1,-1}, {-1,0}, {-1,1}, {0,-1}, {0,1}, {1,-1}, {1,0}, {1,1}]
    |> Enum.map(fn diff -> get_neighbor(state, pos, diff) end)
  end

  def new_seat(state, {pos,v}) do
    neighbor_count = neighbors_of(state, pos) |> Enum.count(fn val -> val == "#" end)
    cond do
      v == "." -> "."
      v == "L" && neighbor_count == 0 -> "#"
      v == "#" && neighbor_count >= 5 -> "L"
      true -> v
    end
  end
  
  def step(state) do
    Enum.reduce(state, %{}, fn {k,v}, acc -> Map.put(acc, k, new_seat(state, {k,v})) end)
  end

  def equal(state, next) do
    Enum.count(state) == Enum.count(next) &&
      Enum.all?(state, fn {k,v} -> Map.get(next, k, nil) == v end)
  end
  
  def step_until_equal(state) do
    next = step(state)
    if equal(state, next), do: state, else: step_until_equal(next)
  end

  def count_occupied(state) do
    Enum.count(state, fn {_k,v} -> v == "#" end)
  end

  def exec(list) do
    create_map(%{}, list, 0)
    |> step_until_equal()
    |> count_occupied()
  end
end

