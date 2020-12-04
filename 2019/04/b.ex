defmodule AdventOfCode201904.B do
  def accumulate(digit, count) do
    case count[digit] do
      nil -> Map.put(count, digit, 1)
      val -> %{count | digit => val + 1}
    end
  end    

  def adjacent_counts(digits) do
    Enum.reduce(digits, %{}, &accumulate/2)
  end

  def adjacent?(digits) do
    adjacent_counts(digits)
    |> Map.values()
    |> Enum.any?(&(&1 == 2))
  end
  
  def increasing?([]), do: true
  def increasing?([_d1]), do: true
  def increasing?([d1,d2]), do: d1 <= d2
  def increasing?([d1,d2|rest]), do: d1 <= d2 && increasing?([d2|rest])
  
  def valid?(number) do
    digits = Integer.digits(number)
    length(digits) == 6 && increasing?(digits) && adjacent?(digits)
  end
  
  def count_valid(range) do
    Enum.reduce(range, 0, fn v, acc -> if valid?(v), do: acc + 1, else: acc end)
  end

  def exec() do
    count_valid(158126..624574)
  end
end

# c "b.ex"
# alias AdventOfCode201904.B
# B.exec()
