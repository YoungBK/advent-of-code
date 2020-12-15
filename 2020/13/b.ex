defmodule AdventOfCode202013.B do
  def read_data() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split(~r/[\n]/)
  end

  def read_csv() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split("\n")
  end

  def read_groups() do
    read_data() |> group()
  end
  
  def test_data() do
"""
939
7,13,x,x,59,x,31,19
""" |> String.trim()
    |> String.split(~r/[\n]/)
  end

  def add_to_group(list, group \\ [])
  def add_to_group([], group), do: {group, nil}
  def add_to_group([answers | rest], group) do
    case answers do
      "" ->
        {group, rest}
      _  ->
        add_to_group(rest, [answers | group])
    end
  end

  def group(list, retlist \\ []) do
    {group, rest} = add_to_group(list)
    case rest do
      nil -> [group | retlist]
      _ -> group(rest, [group | retlist])
    end
  end

  # Parse as list of lists of ???
  # Parse as map of ?
  # Parse as map of maps of ?

  def bus_to_count([], _count), do: []
  def bus_to_count([first|rest], count \\ 0), do: [{first,count}|bus_to_count(rest, count + 1)]
  
  def get_busses([first,second]) do
    second
    |> String.split(",")
    |> bus_to_count()
    |> Enum.reject(fn {bus,count} -> bus == "x" end)
    |> Enum.map(fn {bus,count} -> {String.to_integer(bus), count} end)
  end

  # def find_number([{bus,count}|rest]), do: find_number(rest, {bus,count}, bus)
  # def find_number(list, {bus,count}, attempt) do
  #   case Enum.all?(list, &valid?(&1, {bus,count}, attempt)) do
  #     true -> attempt - count
  #     false -> find_number(list, {bus,count}, attempt + bus)
  #   end
  # end
  # def valid?({bus,count}, {multbus, multcount}, attempt), do: rem(attempt + count - multcount, bus) == 0
  
  # def find_number([{bus,0}|rest]), do: find_number(rest, bus, bus)
  # def find_number(list, multiplier, attempt) do
  #   case Enum.all?(list, &valid?(&1, attempt)) do
  #     true -> attempt
  #     false -> find_number(list, multiplier, attempt + multiplier)
  #    end
  # end
  def valid?({bus,count}, attempt), do: rem(attempt + count, bus) == 0

  def multiply({maxbus,maxcount,maxbase} = max,{bus,count,base} = info, multiplier) do
#    if (maxbase > 10000000) do
#      IO.inspect(max, label: "max")
#      IO.inspect(info, label: "info")
#      Process.exit(self, :normal)
#    end
    ceil((maxbase - base) / (bus * multiplier)) * bus * multiplier + base
#    |> IO.inspect(label: "multiply")
  end

  def multiply_up(_, [], _), do: []
  def multiply_up({a,b,c}=max, [{bus,count,_} = first|rest], multiplier) do
    [{bus, count, multiply(max, first, multiplier)} | multiply_up(max, rest, multiplier)]
#    |> IO.inspect(label: "multiply_up #{multiplier} {#{a},#{b},#{c}}")
  end

  def all_match?([{_,_,base}|rest]), do: Enum.all?(rest, fn {_,_,b} -> b == base end)
  
  def find_number([{_bus,0,_}|rest]), do: find_number(rest, 172159)
  def find_number(list, multiplier) do
#    IO.inspect(list, label: "find_number")
    case all_match?(list) do
      true -> list
      false ->
        Enum.max(list, fn {b1,c1,base1},{b2,c2,base2} -> base1 > base2 end)
        |> multiply_up(list, multiplier)
        |> find_number(multiplier)
    end
  end
  
  def find_match({bus,count}, increment, attempt) do
    case valid?({bus,count}, attempt) do
      true -> {bus,count,attempt}
      false -> find_match({bus,count}, increment, attempt + increment)
    end
  end
  
  def least_common_match([h|_t] = list), do: Enum.map(list, &least_common_match(&1,h))
  def least_common_match({bus,count},{stdbus,0}), do: find_match({bus,count}, stdbus, stdbus)

  def find_rem(match, divisor, start, multiplier) do
    if rem(start * multiplier - 41, divisor) == match do
      multiplier
    else
      find_rem(match, divisor, start, multiplier + 1)
    end
  end

  def find_it(list, start, increment, multiplier) do
    case Enum.all?(list, fn {divisor,remainder} -> rem(start + increment * multiplier, divisor) == remainder end) do
      true -> multiplier
      false ->
#       IO.puts("start = #{start}, increment = #{increment}, multiplier = #{multiplier} list = #{inspect list}")
        if multiplier > 10000, do: Process.exit()
        find_it(list, start, increment, multiplier + 1)
    end
  end
  
  
  def exec(list) do
    list
    |> get_busses()
    |> least_common_match() |> IO.inspect(label: "lcm")
    |> find_number()
#   |> Enum.sort(fn {bus1,_},{bus2,_} -> bus1 >= bus2 end)
#   |> find_number()
  end

  def factors(num, num, ans), do: ans
  def factors(num, next \\ 2, ans \\ []) do
    case floor(num / next) == num / next do
      true -> factors(num,next+1,[next|ans])
      false -> factors(num,next+1,ans)
    end
  end

  #  x | (x % a1) == 0            x == a1 * a3
  #      (x + b2) % b1 == 0       x + b2 == b1 * b3   -> a1 * a3 + b2 == b1 * b3
  #      (x + c2) % c1 == 0       x + c2 == c1 * c3   -> a1 * a3 + c2 == c1 * c3
  #      (x + d2) % d1 == 0       x + d2 == d1 * d3
end

# [
#   {41, 0},
#   {37, 35},
#   {431, 41},
#   {23, 49},
#   {13, 54},
#   {17, 58},
#   {19, 60},
#   {863, 72},
#   {29, 101}
# ]

#13 % 7 = 6
#7 % 6 = 1



# diff 41 863

# 861  
# 862
# 863

# 863 72 (31)
# *1 +2 (to get from multiple of 41 to multiple of 863)
# *2 +4
# *3 +6
# *4 +8
# *5 +10
# *20 +40
# *21 +1
# *36 +31   <----
# *37 +33
# *38 +35
# *39 +37
# *40 +39
# *41 0
# *42 +2
# *77 +31   <---


# 37 35
# *1   x
# *2   33
# *3   29
# *4   25
# *5   21
# *9   5
# *10  1
# *11  38
# *12  34
# *22  35  <----
# *32  36
# *41  0
# *42  37
# *43  33
# *63  35  <----


# 7 0

# 13 1
# 6 13 

# 59 4
# 6 13

# 31 6


# 19 7

# 7

# lcm: [
#   {41, 0, 41},
#   {37, 35, 779},       22, +26 -> 2    (23, 60, ...)   37 * c37 + 23
#   {431, 41, 17630},
#   {23, 49, 779},     4, +22 ->  20     (8, 31, ...     23 * c23 + 8
#   {13, 54, 492},
#   {17, 58, 656},
#   {19, 60, 738},
#   {863, 72, 30996},  611, -211 -> 791   (266, 1129, ...)   863 * c863 + 266
#   {29, 101, 943}     15, -2 -> 15       (1, 30, 59, ...)   29 * c29 + 1
# ]
# x = a * 37 * 41 + 41 * 19   = 41 * (a * 37 + 19)
# x = b * 431 * 41 + 41 * 430 = 41 * (b * 431 + 430)
# x = c * 23 * 41 + 41 * 19   = 41 * (c * 23 + 19)
# x = d * 13 * 41 + 41 * 12   = 41 * (d * 13 + 12)
# x = e * 17 * 41 + 41 * 16   = 41 * (e * 17 + 16)
# x = f * 19 * 41 + 41 * 18   = 41 * (f * 19 + 18)
# x = g * 863 * 41 + 41 * 756 = 41 * (g * 863 + 756)
# x = h * 29 * 41 + 41 * 23   = 41 * (h * 29 + 23)

# 


# x % 41 = 0
# x % 37 = 2    <- x + 41 * 18  = a37 * 37
# x % 431 = 390 <- x + 41       = a431 * 431
# x % 23 = 20   <- x + 41 * 4   = a23 * 23
# x % 13 = 11   <- x + 41       = a13 * 13
# x % 17 = 10   <- x + 41       = a17 * 17
# x % 19 = 16   <- x + 41       = a19 * 19
# x % 863 = 791 <- x + 41 * 107 = a863 * 863
# x % 29 = 15   <- x + 41 * 76  = a29 * 29

# 74200529 = 13 * 17 * 19 * 431 * 41
# 74200488 = 74200529 - 41


# Answer is 556100168221182 - 41 = 556100168221141




# x-2          *
# x        *
# x + 26       *
# x + 41   *   *
# x + 54       *
# x + 72       *
# x + 82   *
# x + 101      *

# x = n * 431 * 13 * 17 * 19 - 41
# x = a37 * 37 - 41 * 18
# x = a23 * 23 - 41 * 4
# x = a863 * 863 - 41 * 107
# x = a29 * 29 - 41 * 76


# n = (a37 * 37 - 41 * 17) / (431 * 13 * 17 * 19) -> (b37 * 37 - 31) / (431 * 13 * 17 * 19) 
# n = (a23 * 23 - 41 * 3) / (431 * 13 * 17 * 19)    -> (b23 * 23 - 8) / (431 * 13 * 17 * 19) 
# n = (a863 * 863 - 41 * 106) / (431 * 13 * 17 * 19)  -> (b863 * 863 - 31) / (431 * 13 * 17 * 19)

# n = (b29 * 29 - 41 * 75) / (431 * 13 * 17 * 19) -> (b29 * 29 - 1) / (431 * 13 * 17 * 19)
# b29 = (n * 431 * 13 * 17 * 19 + 1) / 29


# b29 * 29 = x + 42


# 74200529 - 41 = 74200488
