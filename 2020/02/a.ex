defmodule AdventOfCode202002.A do
  def read_data() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  def read_csv() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split("\n") |> IO.inspect(label: "after split")
    |> Enum.map(&String.split(&1, " "))
  end
  
  def test_data() do
    [
    ]
  end

  def find(_letter, [], count), do: count
  def find(letter, [f|r], count) do
    case f == letter do
      true -> find(letter, r, count + 1)
      false -> find(letter, r, count)
    end
  end
  
  def valid?([range, letter, str]) do
    [s,e] = String.split(range, "-") |> Enum.map(&String.to_integer/1)
    count = find(letter, String.split(str, ""), 0)
    s <= count && count <= e
  end
  
  def count_valid([], count), do: count
  def count_valid([first | rest], count) do
    case valid?(first) do
      true -> count_valid(rest, count + 1)
      false -> count_valid(rest, count)
    end
  end

  def remove_colon([range, letter, str]) do
    newletter = String.split(letter, "") |> Enum.reject(fn v -> v == "" end) |> hd
    [range, newletter, str]
  end

  def exec(list) do
    list
    |> Enum.map(&remove_colon/1)
    |> count_valid(0)
  end
end

#c "a.ex"
#alias AdventOfCode202002.A
# d = A.test_data()
# d = A.read_data()
#d = A.read_csv()
# A.exec(d)
