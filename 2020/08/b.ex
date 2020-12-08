defmodule AdventOfCode202008.B do
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

  def parse_line(line), do: String.split(line, " ")

  def create_program([cmd, numstr], {next_idx, program}) do
    {next_idx + 1, Map.put(program, next_idx, {cmd, String.to_integer(numstr)})}
  end

  def execute_line(program, {acc, executed, idx}) do
    case Map.get(program, idx) do
      {"acc", amount} -> {acc + amount, Map.put(executed, idx, 1), idx + 1}
      {"jmp", amount} -> {acc, Map.put(executed, idx, 1), idx + amount}
      {"nop", _} -> {acc, Map.put(executed, idx, 1), idx + 1}
    end
  end

  def execute({last, program}, {acc, executed, idx} = state \\ {0, %{}, 0}) do
    cond do
      last == idx -> acc
      Map.get(executed, idx, 0) == 1 -> nil
      Map.get(executed, idx, 0) == 0 -> execute({last, program}, execute_line(program, state))
    end
  end

  def try_program({last, program}, {idx, {"jmp", amount}}), do: execute({last, Map.put(program, idx, {"nop",amount})})
  def try_program({last, program}, {idx, {"nop", amount}}), do: execute({last, Map.put(program, idx, {"jmp",amount})})

  def exec_possibles({last, program}) do
    program
    |> Enum.filter(fn {_k,{v,_a}} -> v == "jmp" || v == "nop" end)
    |> Enum.map(&try_program({last,program}, &1))
    |> Enum.reject(&(&1 == nil))
  end

  def exec(list) do
    list
    |> Enum.map(&parse_line/1)
    |> Enum.reduce({0, %{}}, &create_program/2)
    |> exec_possibles()
  end
end
