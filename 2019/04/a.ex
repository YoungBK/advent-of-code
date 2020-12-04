defmodule AdventOfCode201904.A do
  def adjacent?([]), do: false
  def adjacent?([_d1]), do: false
  def adjacent?([d1,d2]), do: d1 == d2
  def adjacent?([d1,d2|rest]), do: d1 == d2 || adjacent?([d2|rest])
  
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

# c "a.ex"
# alias AdventOfCode201904.A
# d = A.test_data()
# d = A.read_data()
# d = A.read_csv()
# A.exec(d)
