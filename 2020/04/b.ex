defmodule AdventOfCode202004.B do
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
pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f
""" |> String.trim()
    |> String.split(~r/[\n ]/)
  end


# eyr:2029 ecl:blu cid:129 byr:1989
# iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm
# 
# hcl:#888785
# hgt:164cm byr:2001 iyr:2015 cid:88
# pid:545766238 ecl:hzl
# eyr:2022
# 
# iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719

  def valid_year?(yearstr, min, max) do
    year = String.to_integer(yearstr)
    min <= year && year <= max
  end

  def valid_height?(height, min, max), do: min <= height && height <= max
  def valid_height?(heightstr) do
    cond do
      String.ends_with?(heightstr, "in") ->
        String.split(heightstr, "in") |> hd() |> String.to_integer() |> valid_height?(59, 76)
      String.ends_with?(heightstr, "cm") ->
        String.split(heightstr, "cm") |> hd() |> String.to_integer() |> valid_height?(150, 193)
      true ->
        false
    end
  end

  def valid_haircolor?(haircolor) do
    try do
      color = String.split(haircolor, "#") |> tl() |> hd() |> String.to_integer(16)
      color >= 0
    catch
      _, _ -> false
    end
  end
  
  def valid_eyecolor?(eyecolor) do
    case eyecolor do
      "amb" -> true
      "blu" -> true
      "brn" -> true
      "gry" -> true
      "grn" -> true
      "hzl" -> true
      "oth" -> true
      _ -> false
    end
  end

  def valid_passportid?(pid) do
    try do
      String.length(pid) == 9 && String.to_integer(pid) >= 0
    catch
      _, _ -> false
    end
  end
  
  # cid (Country ID)
  def valid?(%{"byr" => byr, "iyr" => iyr, "eyr" => eyr, "hgt" => hgt, "hcl" => hcl, "ecl" => ecl, "pid" => pid}) do
    valid_year?(byr, 1920, 2002) && valid_year?(iyr, 2010, 2020) &&
      valid_year?(eyr, 2020, 2030) && valid_height?(hgt) && valid_haircolor?(hcl) &&
      valid_eyecolor?(ecl) && valid_passportid?(pid)
  end
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
      true ->
        # IO.inspect(first, label: "is valid")
        count_valid(rest, count + 1)
      false ->
        # IO.inspect(first, label: "is NOT valid")
        count_valid(rest, count)
    end
  end

  def exec(list) do
    list
    |> group()
    |> count_valid()
  end
end

# c "b.ex"
# alias AdventOfCode202004.B
# d = B.test_data()
# d = B.read_data()
# d = B.read_csv()
# B.exec(d)
