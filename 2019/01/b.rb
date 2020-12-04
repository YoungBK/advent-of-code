def calc_fuel(weight, list = [])
  fuel = calc_fuel_basic(weight)
  if fuel > 0
    list << fuel
    calc_fuel(fuel, list)
  else
    return list
  end
end

def calc_fuel_basic(weight)
  weight / 3 - 2
end

lines = File.read("data.txt").split("\n")
puts lines.map { |w| calc_fuel(w.to_i) }.flatten.sum
