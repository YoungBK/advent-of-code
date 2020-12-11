defmodule AdventOfCode202010.B do
  def read_data() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split(~r/[\n]/)
    |> Enum.map(&String.to_integer/1)
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
28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3    
""" |> String.trim()
    |> String.split(~r/[\n]/)
    |> Enum.map(&String.to_integer/1)
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

  def create_list([first|rest], count, acc \\ []) do
    cond do
      count == 0 -> {Enum.reverse(acc), [first|rest]}
      true -> create_list(rest, count - 1, [first|acc])
    end
  end

  def exists_pair?(list, element) do
    Enum.any?(list, fn el -> Enum.find(list, fn x -> x == element - el end) end)
  end
  
  def find_wrong({list, [first|rest]}) do
    case exists_pair?(list, first) do
      true -> find_wrong({tl(list) ++ [first], rest})
      false -> first
    end
  end

  def find_differences([], result), do: result
  def find_differences([first], result), do: result ++ [3]
  def find_differences([first|rest]), do: find_differences([first|rest], [first])
  def find_differences([first,second|rest], result) do
    find_differences([second|rest], result ++ [second - first])
  end

  def runs_of_ones(list, count, result \\ [])
  def runs_of_ones([], 0, result), do: result
  def runs_of_ones([1|rest], count, result), do: runs_of_ones(rest, count + 1, result)
  def runs_of_ones([3|rest], 0, result), do: runs_of_ones(rest, 0, result)
  def runs_of_ones([3|rest], count, result), do: runs_of_ones(rest, 0, [count|result])

  def convert_to_combination_count(num) do
    case num do
      1 -> 1
      2 -> 2
      3 -> 4
      4 -> 7
    end
  end
  
  def exec(list) do
    list
    |> Enum.sort()
    |> find_differences()
    |> runs_of_ones(0)
    |> Enum.map(&convert_to_combination_count/1)
    |> Enum.reduce(1, &(&1 * &2))

#    ones * threes
#    |> create_list(25)
#    |> find_wrong()
  end
end

# (0) 1 4 7 10 (14)   <-  1 way

# (0) 1 4 7 8 (11) <- 1 way because cannot jump from 7 to 11

# (0) 1 4 5 8 (11) <- 1 way because cannot jump from 7 to 11
  
# if the difference is 3 1 3 then there is still only one way

# (0) 1 4 7 8 9 (12)
# (0) 1 4 7 9 (12)       3113 <- can be reduced to 323
#
# (0) 1 4 7 8 9 10 (13)       31113 <- can be reduced to 323
# (0) 1 4 7 8 10 (13)       31113 <- can be reduced to 323
# (0) 1 4 7 9 10 (13)       31113 <- can be reduced to 323
# (0) 1 4 7 10 (13)       31113 <- can be reduced to 323

# 111
# 2 1
# 1 2
# 3
# 3 -> 4

# 1111
# 112
# 13
# 121
# 211
# 22
# 31

# 2 -> 2
# 4 -> 7


# so get the runs of 1s
# then count the number of distinct ways each can be combined to form 3 or fewer
# then multiply all of those together


# So, count of the different combinations of the differences that will add up to 3 or less


# 0, 1,2,5,6,7
# 0, 2, 5, 6, 7

# (0) [1 2] 3 4 5 6 7/10 11/(14)
# (0) 1 [2 3] 4 5 6 7/10 11/(14)

# 0 2 3 4 5 6 7 10
# 0 2 4 5 6 7 10
# 0 2 5 6 7 10

# 0 3 4 5 6 6 10

# from each element
#   count the number of elements it can connect to
