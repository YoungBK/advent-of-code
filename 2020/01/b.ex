defmodule AdventOfCode202001.B do
  def read_data() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  def try_triples(_first, _second, [], fun), do: nil
  def try_triples(first, second, [third | rest], fun) do
    case fun.(first, second, third) do
      true -> {first, second, third}
      false -> try_triples(first, second, rest, fun)
    end
  end
  
  def try_pairs(_first, [], _fun), do: nil
  def try_pairs(first, [second | rest], fun) do
    case try_triples(first, second, rest, fun) do
      nil -> try_pairs(first, rest, fun)
      answer -> answer
    end
  end

  def find_triple([], _fun), do: nil
  def find_triple([first | rest], fun) do
    case try_pairs(first, rest, fun) do
      nil -> find_triple(rest, fun)
      answer -> answer
    end
  end

  def make_product(nil), do: "fail!"
  def make_product({x,y,z}), do: x * y * z

  def exec(list) do
    list
    |> find_triple(fn x,y,z -> x + y + z == 2020 end)
    |> make_product()
  end
end
