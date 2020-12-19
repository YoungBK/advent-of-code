defmodule AdventOfCode202018.B do
  use Bitwise
  
  def read_data() do
    File.read!("input.txt")
    |> String.trim()
    |> String.split(~r/[\n]/)
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&Enum.reject(&1, fn v -> v == " " end))
    |> Enum.map(&Enum.map(&1, fn v -> if String.match?(v, ~r/^[[:digit:]]+$/), do: String.to_integer(v), else: v end))
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
    # 51 600
# 1 + (2 * 3) + (4 * (5 + 6)) -> 51
# (4 + 7 * 6 * 5) -> 330
# (4 + (4 + 7 * 6 * 5) + 6) -> 340
# (4 + (4 + 7 * 6 * 5) + 6) + (3 * 2 + 2) + 3 + (8 * 5 * 6) + 9 -> 600
# 6 * ((5 * 3 * 2 + 9 * 4) * (8 * 8 + 2 * 3) * 5 * 8) * 2 + (4 + 9 * 5 * 5 + 8) * 4
# (2 + 4 * 9) * (6 + 9 * 8 + 6) + 6 -> 6810 but gives 7128
    
#((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6)
#2 + (4 + 9) + 5  -> 20
#((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) -> 11664
#9 + 3 * (3 + 3 * 2 + 4) * 2 * (5 + 9 * 9 * (2 + 5 * 2 * 4) * 6)
# 1 + (2 * 3) + (4 * (5 + 6)) -> 51
# 2 * 3 + (4 * 5) -> 46
# 5 + (8 * 3 + 9 + 3 * 4 * 3) -> 1445
# 5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4)) -> 669060
# ((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2 -> 23340
"""
1 + (2 * 3) + (4 * (5 + 6))
2 * 3 + (4 * 5)
5 + (8 * 3 + 9 + 3 * 4 * 3)
5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))
((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2
""" |> String.trim()
    |> String.split(~r/[\n]/)
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(&Enum.reject(&1, fn v -> v == " " end))
    |> Enum.map(&Enum.map(&1, fn v -> if String.match?(v, ~r/^[[:digit:]]+$/), do: String.to_integer(v), else: v end))
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
  def match_parens(list, -1, [")"|acc]), do: {Enum.reverse(acc), list}
  def match_parens(list, -1, _), do: raise "This is broken"
  def match_parens([first|rest], depth \\ 0, acc \\ []) do
    case first do
      "(" -> match_parens(rest, depth + 1, [first|acc])
      ")" -> match_parens(rest, depth - 1, [first|acc])
      char -> match_parens(rest, depth, [char|acc])
    end
  end

  # def evaluate(_op, [x]) when is_integer(x), do: x |> IO.inspect(label: "evaluate one x")
  # def evaluate(op, [x, op, y|rest]) when is_integer(x) and is_integer(y) do
  #   IO.inspect(op, label: "evaluate second op")
  #   IO.inspect([x, op, y|rest], label: "evaluate second list")
  #   case op do
  #     "+" -> evaluate(op, [x + y|rest])
  #     "*" -> evaluate(op, [x * y|rest])
  #   end
  # end
  # def evaluate(op, [x, diff_op, y|rest]) when is_integer(x) and is_integer(y) do
  #   IO.inspect(op, label: "evaluate third op")
  #   IO.inspect([x, diff_op, y|rest], label: "evaluate third list")
  #   case evaluate(op, [y|rest]) do
  #     new when is_integer(new) -> [x, diff_op, new]
  #     [_h|_t] = list -> [x, diff_op | list]
  #   end
  # end
  # def evaluate(op, [x, op2, [_|_] = list|rest]) when is_integer(x) do
  #   IO.inspect(op, label: "evaluate fourth op")
  #   IO.inspect([x, op2, list|rest], label: "evaluate fourth list")
  #   case evaluate(op, [y|rest]) do
  #     new when is_integer(new) -> [x, diff_op, new]
  #     [_h|_t] = list -> [x, diff_op | list]
  #   end
  # end
  # # def evaluate(op, [[_|_] = list, op|rest] = complete) do
  # #   IO.inspect(op, label: "evaluate fourth op")
  # #   IO.inspect([list, op|rest], label: "evaluate fourth list")
  # #   # evaluate(op, [evaluate(op, list), op|rest])
  # #   evaluated = [evaluate(op, list), op|rest] |> IO.inspect(label: "evaluate fourth evaluated")
  # #   if evaluated == complete, do: complete, else: evaluate(op, evaluated)
  # # end
  # def evaluate(op, [[_|_] = list, diff_op|rest]) do
  #   IO.inspect(op, label: "evaluate fifth op")
  #   IO.inspect([list, diff_op|rest], label: "evaluate fifth list")
  #   evaluated = evaluate(op, list)
  #   case evaluated == list do
  #     true ->
  #       case evaluate(op, rest) do
  #         new when is_integer(new) -> [evaluated, diff_op, new]
  #         [_h|_t] = list -> [evaluated, diff_op | list]
  #       end
  #     false -> evaluate(op, [evaluated, diff_op|rest])
  #   end
  # end

  def evaluate(x, _op) when is_integer(x), do: x # |> IO.inspect(label: "evaluate one x", charlists: :as_lists)
  def evaluate([x], _op) when is_integer(x), do: x # |> IO.inspect(label: "evaluate one [x]", charlists: :as_lists)
  def evaluate([x, op, y|rest], op) when is_integer(x) and is_integer(y) do
    # IO.inspect(op, label: "evaluate second op", charlists: :as_lists)
    # IO.inspect([x, op, y|rest], label: "evaluate second list", charlists: :as_lists)
    case op do
      "+" ->
        evaluate([x + y|rest], op)
        # |> IO.inspect(label: "evaluate second + evaluate result", charlists: :as_lists)
      "*" ->
        evaluate([x * y|rest], op)
        # |> IO.inspect(label: "evaluate second * evaluate result", charlists: :as_lists)
    end
  end
  def evaluate([x, op, y|rest], op2) when is_integer(x) and is_integer(y) do
    # IO.inspect(op2, label: "evaluate third op2", charlists: :as_lists)
    # IO.inspect([x, op, y|rest], label: "evaluate third list", charlists: :as_lists)
    case rest do
      [] -> [x, op, y] # |> IO.inspect(label: "evaluate third result 1", charlists: :as_lists)
      _ ->
        case evaluate([y|rest], op2) do
          [_|_] = list -> [x, op | list] # |>  IO.inspect(label: "evaluate third result 2", charlists: :as_lists)
          value -> [x, op, value] # |>  IO.inspect(label: "evaluate third result 3", charlists: :as_lists)
        end
    end
  end
  # def evaluate_list_first(op, [[_|_] = list, op|rest] = complete) do
  #   IO.inspect(op, label: "evaluate_list_first fourth op")
  #   IO.inspect([list, op|rest], label: "evaluate_list_first fourth list")
  #   # evaluate_list_first(op, [evaluate_list_first(op, list), op|rest])
  #   evaluate_list_firstd = [evaluate_list_first(op, list), op|rest] |> IO.inspect(label: "evaluate_list_first fourth evaluate_list_firstd")
  #   if evaluate_list_firstd == complete, do: complete, else: evaluate_list_first(op, evaluate_list_firstd)
  # end
  def evaluate_list_first(list) do
    # IO.inspect(list, label: "evaluate_list_first list", charlists: :as_lists)
    
    Enum.map(list, fn el -> if is_list(el), do: evaluate_list_first(el), else: el end)
    # |> IO.inspect(label: "evaluate_list_first mapped values", charlists: :as_lists)
    |> evaluate("+")
    |> evaluate("*")
  end

  def convert_expressions_to_list([x, op, "("|rest]) when is_integer(x) do
    # IO.inspect(x, label: "convert_expressions_to_list 1 x", charlists: :as_lists)
    # IO.inspect(op, label: "convert_expressions_to_list 1 op", charlists: :as_lists)
    # IO.inspect(rest, label: "convert_expressions_to_list 1 rest", charlists: :as_lists)
    {list, remainder} = match_parens(rest) # |> IO.inspect(label: "convert_expressions_to_list 1 match_parens result", charlists: :as_lists)
    case remainder do
      [] -> [x, op, convert_expressions_to_list(list)]
      [nextop|rem_rest] -> [x, op, convert_expressions_to_list(list), nextop | convert_expressions_to_list(rem_rest)]
    end
  end
  def convert_expressions_to_list(["("|rest]) do
    # IO.inspect(rest, label: "convert_expressions_to_list 2 rest", charlists: :as_lists)
    {list, remainder} = match_parens(rest) # |> IO.inspect(label: "convert_expressions_to_list 2 match_parens result", charlists: :as_lists)
    case remainder do
      [] -> [convert_expressions_to_list(list)]
      [op|rem_rest] when op in ["*","+"] -> [convert_expressions_to_list(list), op | convert_expressions_to_list(rem_rest)]
    end
  end
  def convert_expressions_to_list([x, op|rest]) when is_integer(x) do
    # IO.inspect(x, label: "convert_expressions_to_list 3 x", charlists: :as_lists)
    # IO.inspect(op, label: "convert_expressions_to_list 3 op", charlists: :as_lists)
    # IO.inspect(rest, label: "convert_expressions_to_list 3 rest", charlists: :as_lists)
    [x, op |convert_expressions_to_list(rest)]
  end
  def convert_expressions_to_list([x]) when is_integer(x), do: [x]
  
  # evaluate parenthesized expressions
  # evaluate + expressions
  # evaluate * expressions

  def exec(list) do
    list # |> IO.inspect(label: "list", charlists: :as_lists)
    |> Enum.map(&convert_expressions_to_list/1)
    |> IO.inspect(label: "converted", charlists: :as_lists)
    |> Enum.map(&evaluate_list_first/1)
    |> IO.inspect(label: "answers", charlists: :as_lists)
    |> Enum.sum()
#    |> Enum.sum()
#    |> count_occupied()
  end
end



5 + (8 * 3 + 9 + 3 * 4 * 3)





5 + (8 * 3 + 9 + 3 * 4 * 3)






