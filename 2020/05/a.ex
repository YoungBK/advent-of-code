defmodule AdventOfCode202005.A do
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

  def exec(list) do
    list
#    |> Enum.count(&match_fun/1)
    |> Enum.map(&calc_seat_id/1)
    |> Enum.max()
  end
end

# c "a.ex"
# alias AdventOfCode202004.A
# d = A.test_data()
# d = A.read_data()
# d = A.read_csv()
# A.exec(d)
