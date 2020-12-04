defmodule AdventOfCode202001.A do
  def read_data() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  def try_pairs(_first, [], _fun), do: nil
  def try_pairs(first, [second | rest], fun) do
    case fun.(first, second) do
      true -> {first, second}
      false -> try_pairs(first, rest, fun)
    end
  end

  def find_pair([], _fun), do: nil
  def find_pair([first | rest], fun) do
    case try_pairs(first, rest, fun) do
      nil -> find_pair(rest, fun)
      answer -> answer
    end
  end

  def make_product(nil), do: "fail!"
  def make_product({x,y}), do: x * y

  def exec(list) do
    list
    |> find_pair(fn x,y -> x + y == 2020 end)
    |> make_product()
  end
end
