defmodule AdventOfCode202016.B do
  use Bitwise
  
  def read_data() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split(~r/[\n]/)
  end

  def read_csv() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn s -> String.split(s, ",") end)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
  end

  def read_groups() do
    read_data() |> group()
  end
  
  def test_data() do
"""
class: 0-1 or 4-19
row: 0-5 or 8-19
seat: 0-13 or 16-19

your ticket:
11,12,13

nearby tickets:
3,9,18
15,1,5
5,14,9
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

  def values_reduce(startv, endv, hash) do
    Enum.reduce((startv..endv), hash, fn n,h -> Map.put(h, n, true) end)
  end
  
  def add_to_valid_values(hash, [r1start, r1end, r2start, r2end]) do
    values_reduce(r1start, r1end, values_reduce(r2start, r2end, hash))
  end

  def fields_reduce(field, startv, endv, hash) do
    Enum.reduce((startv..endv), hash, fn n,h -> Map.put(h, n, [field|Map.get(h, n, [])]) end)
  end
  def add_to_valid_fields(hash, field, [r1start, r1end, r2start, r2end]) do
    fields_reduce(field, r1start, r1end, fields_reduce(field, r2start, r2end, hash))
  end
  
  def parse_field(string) do
    IO.inspect(string, label: "parse_field")
    [field, numbers] = String.split(string, ": ")
    {field, String.split(numbers, ~r/-| or /) |> Enum.map(&String.to_integer/1)}
  end
  def parse_fields([first|rest] = list, info \\ %{__valid_values: %{}, __valid_fields: %{}}) do
    cond do
      first == "" -> {rest, info}
      true ->
        {field, ranges} = parse_field(first)
        parse_fields(rest, Map.put(info, field, ranges)
                           |> Map.put(:__valid_values, add_to_valid_values(Map.get(info, :__valid_values), ranges))
                           |> Map.put(:__valid_fields, add_to_valid_fields(Map.get(info, :__valid_fields), field, ranges))
          )
    end
  end

  def parse_your_ticket({["your ticket:",ticket,blank|list], info}) do
    {list, Map.put(info, :__your_ticket, parse_ticket(ticket))}
  end

  def parse_nearby_tickets({["nearby tickets:"|list], info}) do
    Map.put(info, :__nearby_tickets, Enum.map(list, &parse_ticket/1))
  end

  def parse_ticket(ticket) do
    ticket |> String.split(",") |> Enum.map(&String.to_integer/1)
  end

  def find_invalid_values({["nearby tickets:"|list], valid_values}, acc \\ []) do
    find_invalid_values(list, valid_values, acc)
  end
  def find_invalid_values([], valid_values, acc), do: acc
  def find_invalid_values([first|rest], valid_values, acc) do
    IO.inspect(first, label: "find_invalid_values")
    find_invalid_values(
      rest,
      valid_values,
      acc ++ (String.split(first, ",") |> Enum.map(&String.to_integer/1) |> Enum.reject(fn n -> valid_values[n] == true end))
    )
  end

  def has_invalid_value?(ticket, valid_values) do
    Enum.any?(ticket, fn n -> valid_values[n] != true end) |> IO.inspect(label: "has_invalid_value?")
  end
  
  def reject_invalid_nearby_tickets(%{__nearby_tickets: nearby} = info) do
    Map.put(info, :__nearby_tickets, Enum.reject(nearby, &has_invalid_value?(&1, info.__valid_values)))
  end

  def calc_field_positions(info) do
    calc_field_positions(info, info.__nearby_tickets, [])
  end
  def calc_field_positions(info, tickets, acc) do
    cond do
      hd(tickets) == [] -> {info, Enum.reverse(acc)}     # reverse them here
      true -> 
        fields = tickets
        |> Enum.map(&hd/1)
        |> Enum.map(&Map.get(info.__valid_fields, &1, []))
        |> Enum.reduce(fn list,acc -> acc -- (acc -- list) end)
        calc_field_positions(info, tickets |> Enum.map(&tl/1), [fields|acc])   # adding the lists of possible fields in reverse order
    end
  end

  def cleanup_singles(field, field_positions) do
    Enum.map(field_positions, fn v -> if Enum.count(v) > 1, do: v -- field, else: v end)
  end
  
  def reduce_field_positions({info, field_positions}) do
    new_field_positions = field_positions
    # Handle where there's only one
    |> Enum.filter(fn p -> Enum.count(p) == 1 end)
    |> Enum.reduce(field_positions, &cleanup_singles(&1, &2))

    if new_field_positions == field_positions do
      {info, field_positions}
    else
      reduce_field_positions({info, new_field_positions})
    end
  end

  def pick_departure_fields({info, field_positions}) do
    pick_departure_fields(info.__your_ticket, List.flatten(field_positions))
  end
  def pick_departure_fields([], [], acc), do: acc
  def pick_departure_fields([field|ticket], [fieldname|fields], acc \\ 1) do
    IO.inspect(fieldname, label: "fieldname")
    IO.inspect(field, label: "field")
    case fieldname do
      "departure" <> _other -> pick_departure_fields(ticket, fields, acc * field)
      _other -> pick_departure_fields(ticket, fields, acc)
    end
  end

  def exec(list) do
    list
    |> parse_fields()
    |> parse_your_ticket()
    |> parse_nearby_tickets()
    |> reject_invalid_nearby_tickets()
    |> calc_field_positions()
    |> reduce_field_positions()
    |> pick_departure_fields()
  end
end

