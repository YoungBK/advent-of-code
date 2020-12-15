defmodule AdventOfCode202014.A do
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
  end

  def read_groups() do
    read_data() |> group()
  end
  
  def test_data() do
"""
mask = XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X
mem[8] = 11
mem[7] = 101
mem[8] = 0
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

  def and_mask([], acc), do: acc
  def and_mask([first|rest], acc \\ 0) do
    case first do
      "0" -> and_mask(rest, acc * 2)
      "1" -> and_mask(rest, acc * 2)
      "X" -> and_mask(rest, acc * 2 + 1)
    end
  end

  def or_mask([], acc), do: acc
  def or_mask([first|rest], acc \\ 0) do
    case first do
      "0" -> or_mask(rest, acc * 2)
      "1" -> or_mask(rest, acc * 2 + 1)
      "X" -> or_mask(rest, acc * 2)
    end
  end

  def set_memory([address, value], memory) do
    Map.put(memory, address, (memory.and_mask &&& value) + memory.or_mask)
  end

  def grab_values(setstring) do
    String.split(setstring, "] = ") |> Enum.map(&String.to_integer/1)
  end
  
  def exec_command("mask = " <> bitmask, memory) do
    Map.put(memory, :and_mask, and_mask(String.graphemes(bitmask)))
    |> Map.put(:or_mask, or_mask(String.graphemes(bitmask)))
  end
  def exec_command("mem[" <> memoryset, memory) do
    memoryset
    |> grab_values()
    |> set_memory(memory)
  end

  def exec_commands([], memory), do: memory
  def exec_commands([first|rest], memory), do: exec_commands(rest, exec_command(first, memory))

  def exec(list) do
    list
    |> exec_commands(%{}) |> IO.inspect(label: "memory")
    |> Enum.reduce(0, fn {k,v},acc -> if is_number(k), do: acc + v, else: acc end)
  end
end

# mask   data

# 1       1 ->    1    or
# 1       0 ->    1

# X       1 ->    1    and
# X       0 ->    0


# 0       1 ->    0    and
# 0       0 ->    0
