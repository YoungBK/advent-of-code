def calc_fuel(weight)
  weight / 3 - 2
end

lines = File.read("data.txt").split("\n")
puts lines.map { |w| calc_fuel(w.to_i) }.sum
