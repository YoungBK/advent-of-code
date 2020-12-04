class Computer
  attr_reader :program
  
  def initialize(program)
    @program = program
  end

  def reset(values)
    program.each_with_index { |_,i| program[i] = values[i] }
  end

  def set(noun, verb)
    program[1] = noun
    program[2] = verb
  end
  
  def execute
    position = 0
    until program[position] == 99
      execute_command(position)
      position += 4
    end
    return program[0]
  end

  def execute_command(position)
    case program[position]
    when 1
      program[program[position + 3]] = program[program[position + 1]] + program[program[position + 2]] 
    when 2
      program[program[position + 3]] = program[program[position + 1]] * program[program[position + 2]] 
    else
      raise "Bad number position = #{position} program = #{program.inspect}"
    end
  end
end

class ProgramRunner
  attr_reader :original, :computer
  def initialize
    @original = File.read("data.txt").split(",").map(&:to_i)
    @computer = Computer.new(original.clone)
  end

  def run(noun, verb)
    computer.set(noun, verb)
    computer.execute
  end

  def try_all_combos
    (0..99).each do |noun|
      (0..99).each do |verb|
        computer.reset(original)
        answer = run(noun, verb)
        return [noun, verb] if answer == 19690720
      end
    end
  end
end
