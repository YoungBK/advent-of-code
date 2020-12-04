def execute(program)
  position = 0
  until program[position] == 99
    execute_command(program, position)
    position += 4
  end
  return program
end

def execute_command(program, position)
  case program[position]
  when 1
    program[program[position + 3]] = program[program[position + 1]] + program[program[position + 2]] 
  when 2
    program[program[position + 3]] = program[program[position + 1]] * program[program[position + 2]] 
  else
    raise "Bad number position = #{position} program = #{program.inspect}"
  end
end

def run
  program = File.read("data.txt").split(",").map(&:to_i)
  program[1] = 12
  program[2] = 2
  execute(program)
end
