defmodule AdventOfCode202002.B do
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
      ["1-3", "a:", "abcde"],
      ["1-3", "b:", "cdefg"],
      ["2-9", "c:", "ccccccccc"]
    ]
  end

  def find(_letter, [], _index), do: false
  def find(letter, [f|r], index) do
    cond do
      index == 1 -> f == letter
      true -> find(letter, r, index - 1)
    end
  end
  
  def valid?([indexes, letter, str]) do
    [i1,i2] = String.split(indexes, "-") |> Enum.map(&String.to_integer/1)
    valid1 = find(letter, String.split(str, "") |> Enum.reject(fn v -> v == "" end), i1)
    valid2 = find(letter, String.split(str, "") |> Enum.reject(fn v -> v == "" end), i2)
    (valid1 && !valid2) || (valid2 && !valid1)
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

#c "b.ex"
#alias AdventOfCode202002.B
# d = B.test_data()
# d = B.read_data()
#d = B.read_csv()
# B.exec(d)

