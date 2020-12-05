defmodule AdventOfCode202005.B do
  def read_data() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split(~r/[\n ]/)
  end

  def read_csv() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split("\n")
  end
  
  def test_data() do
"""    
""" |> String.trim()
    |> String.split(~r/[\n ]/)
  end

  # BFFFBBF
  # 1000110

  # R=1
  # L=0
  # B=1
  # F=0

  def convert(letter) do
    case letter do
      "B" -> 1
      "F" -> 0
      "R" -> 1
      "L" -> 0
    end
  end

  def calc_seat_id(seat_position) do
    String.graphemes(seat_position)
    |> Enum.reduce(0, fn l, a -> convert(l) + 2*a end)
  end

  def find_missing([first|rest], prev) do
    cond do
      first == prev + 1 -> find_missing(rest, first)
      true -> prev + 1
    end
  end
  def find_missing([first|rest]) do
    find_missing(rest, first)
  end

  def exec(list) do
    list
    |> Enum.map(&calc_seat_id/1)
    |> Enum.sort()
    |> find_missing()
  end
end

# c "b.ex"
# alias AdventOfCode202004.B
# d = B.test_data()
# d = B.read_data()
# d = B.read_csv()
# B.exec(d)
