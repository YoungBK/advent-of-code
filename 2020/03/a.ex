defmodule AdventOfCode202003.A do
  def read_data() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split()
  end

  def read_csv() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split("\n")
  end
  
  def test_data() do
    [
    ]
  end

  def char_at([first|rest], 0), do: first
  def char_at([first|rest], count), do: char_at(rest, count - 1)
  
  def traverse([], right, down, position, count), do: count
  def traverse([current | next | rest], right, down, position, count) do
    pos = rem(position, String.length(current))
    case char_at(String.graphemes(current), pos) do
      "#" -> traverse(rest, pos + right, count + 1)
      _ -> traverse(rest, pos + right, count)
    end
  end

  def exec(list) do
    traverse(list, 0, 0)
  end
end

# c "a.ex"
# alias AdventOfCode202003.A
# d = A.test_data()
# d = A.read_data()
# d = A.read_csv()
# A.exec(d)
