defmodule AdventOfCode202003.B do
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
  def traverse([current], right, _, position, count) do
    pos = rem(position, String.length(current))
    case char_at(String.graphemes(current), pos) do
      "#" -> count + 1
      _ -> count
    end
  end
  def traverse([current, next], right, down, position, count) do
    pos = rem(position, String.length(current))
    case char_at(String.graphemes(current), pos) do
      "#" -> if down == 2, do: count + 1, else: traverse([next], right, down, pos + right, count + 1)
      _ -> if down == 2, do: count, else: traverse([next], right, down, pos + right, count)
    end
  end
  def traverse([current, next | rest], right, down, position, count) do
    pos = rem(position, String.length(current))
    case char_at(String.graphemes(current), pos) do
      "#" -> if down == 2, do: traverse(rest, right, down, pos + right, count + 1), else: traverse([next | rest], right, down, pos + right, count + 1)
      _ -> if down == 2, do: traverse(rest, right, down, pos + right, count), else: traverse([next | rest], right, down, pos + right, count)
    end
  end

  def exec(list) do
    traverse(list, 1, 1, 0, 0) *
    traverse(list, 3, 1, 0, 0) *
    traverse(list, 5, 1, 0, 0) *
    traverse(list, 7, 1, 0, 0) *
    traverse(list, 1, 2, 0, 0)
  end
end

# c "b.ex"
# alias AdventOfCode202003.B
# d = B.test_data()
# d = B.read_data()
# d = B.read_csv()
# B.exec(d)
