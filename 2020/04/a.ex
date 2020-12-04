defmodule AdventOfCode202004.A do
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
    [
    ]
  end

  # cid (Country ID)
  def valid?(%{"byr" => _, "iyr" => _, "eyr" => _, "hgt" => _, "hcl" => _, "ecl" => _, "pid" => _}), do: true
  def valid?(_), do: false
               
  def add_to_passport(list, passport \\ %{})
  def add_to_passport([], passport), do: {passport, nil}
  def add_to_passport([key_val | rest] = list, passport) do
    # IO.inspect(passport, label: "add_to_passport passport")
    # IO.inspect(list, label: "add_to_passport list")
    # IO.inspect(key_val, label: "add_to_passport key_val")
    case key_val do
      "" ->
        {passport, rest}
      _  ->
        [key, val] = String.split(key_val, ":")
        add_to_passport(rest, Map.put(passport, key, val))
    end
  end

  def group(list, retlist \\ []) do
    # IO.inspect(retlist, label: "group retlist")
    {passport, rest} = add_to_passport(list)
    case rest do
      nil -> [passport | retlist]
      _ -> group(rest, [passport | retlist])
    end
  end

  def count_valid([], count), do: count
  def count_valid([first | rest], count \\ 0) do
    case valid?(first) do
      true -> count_valid(rest, count + 1)
      false -> count_valid(rest, count)
    end
  end

  def exec(list) do
    list
    |> group()
    |> count_valid()
  end
end

# c "a.ex"
# alias AdventOfCode202004.A
# d = A.test_data()
# d = A.read_data()
# d = A.read_csv()
# A.exec(d)
