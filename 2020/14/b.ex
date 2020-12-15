defmodule AdventOfCode202014.B do
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
mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1
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

  def apply_mask([], acc), do: acc
  def or_mask([first|rest], acc \\ 0) do
    case first do
      "0" -> or_mask(rest, acc * 2 + 1)
      "1" -> or_mask(rest, acc * 2)
      "X" -> or_mask(rest, acc * 2)
    end
  end

  def gen([], [], partial_addr), do: [Enum.reduce(partial_addr, 0, fn b,a -> a*2 + String.to_integer(b) end)]
  def gen([] = _rev_addr, [mask_bit|mask_rest] = _rev_mask, partial_addr) do
    case mask_bit do
      "X" ->
        gen([], mask_rest, ["0"|partial_addr]) ++ gen([], mask_rest, ["1"|partial_addr])
      "1" ->
        gen([], mask_rest, ["1"|partial_addr])
      "0" ->
        gen([], mask_rest, ["0"|partial_addr])
    end
  end
  def gen([addr_bit|addr_rest] = _rev_addr, [mask_bit|mask_rest] = _rev_mask, partial_addr \\ []) do
    case mask_bit do
      "X" ->
        # IO.inspect(mask_rest, label: "gen: X mask_rest")
        # IO.inspect(addr_rest, label: "gen: X addr_rest")
        # IO.inspect(partial_addr, label: "gen: X partial_addr")
        # IO.inspect(["1"|partial_addr], label: "gen: X partial_addr with 1 prefix")
        gen(addr_rest, mask_rest, ["0"|partial_addr]) ++ gen(addr_rest, mask_rest, ["1"|partial_addr])
      "1" ->
        gen(addr_rest, mask_rest, ["1"|partial_addr])
      "0" ->
        gen(addr_rest, mask_rest, [addr_bit|partial_addr])
    end
  end

  def gen_addresses_start(mask, address) do
    address
    # |> IO.inspect(label: "address")
    |> String.to_integer()
    |> Integer.to_string(2)
    |> String.reverse()
    |> String.graphemes()
    |> gen(Enum.reverse(mask))
  end

  def set_memory_locations([address, value], memory) do
    gen_addresses_start(memory.current_mask, address)
    |> Enum.reduce(memory, fn addr,acc -> Map.put(acc, addr, value) end)
  end

  def grab_values(setstring) do
    String.split(setstring, "] = ") # |> Enum.map(&String.to_integer/1)
  end
  
  def exec_command("mask = " <> bitmask, memory), do: Map.put(memory, :current_mask, String.graphemes(bitmask))
  def exec_command("mem[" <> memoryset, memory) do
    memoryset
    |> grab_values()
    |> set_memory_locations(memory)
  end

  def exec_commands([], memory), do: memory
  def exec_commands([first|rest], memory), do: exec_commands(rest, exec_command(first, memory))

  # def create_address([], []), do: []
  # def create_address(mask, []), do: []
  # def create_address([], addr), do: []
  # def create_address([mask_head|mask_rest], [addr_head|addr_rest]) do
  # end

  # def convert_address(mask, address) do
  #   working_address = Integer.to_string(address, 2) |> String.reverse()
  #   working_mask = String.reverse(mask)
  # end
  
  # def convert_to_instruction([address, value], memory) do
  #   instruction = {convert_address(memory.current_mask, address), value}
  #   Map.put(memory, :instructions, [instruction|memory.instructions])
  # end

  def apply_values(memory), do: memory

  def exec(list) do
    list
    # |> IO.inspect(label: "list")
    |> exec_commands(%{})
    |> Enum.reduce(0, fn {k,v},a -> if is_number(k), do: a + String.to_integer(v), else: a end)
  end
end

# mask   data

# 1       1 ->    1    or
# 1       0 ->    1

# X       1 ->    1    and
# X       0 ->    0


# 0       1 ->    0    and
# 0       0 ->    0
