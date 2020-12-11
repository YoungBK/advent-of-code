class Seats
  attr_accessor :original

  def self.read_data()
    File.read("input.txt").split("\n").map { |x| x.split("") }
  end
  def self.test_data()
    data = <<-DATA
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
DATA
    data.split("\n").map { |x| x.split("") }
  end

  def initialize(data)
    @original = data
  end

  def neighbors(rowidx, colidx)
    [[rowidx - 1, colidx - 1],
     [rowidx - 1, colidx],
     [rowidx - 1, colidx + 1],
     [rowidx, colidx - 1],
     [rowidx, colidx + 1],
     [rowidx + 1, colidx - 1],
     [rowidx + 1, colidx],
     [rowidx + 1, colidx + 1]].select {|r,c| r >= 0 && r < original.length && c >= 0 && c < original[0].length}
  end

  def count_neighbor(state, rowidx, colidx, rdiff, cdiff)
    while true do
      rowidx += rdiff
      colidx += cdiff
      return 0 if rowidx < 0 || rowidx >= original.length || colidx < 0 || colidx >= original[0].length
      return 1 if state[rowidx][colidx] == "#"
      return 0 if state[rowidx][colidx] == "L"
    end
  end

  def count_neighbors(state, rowidx, colidx)
    count_neighbor(state, rowidx, colidx, -1, -1) +
      count_neighbor(state, rowidx, colidx, -1, 0) +
      count_neighbor(state, rowidx, colidx, -1, 1) +
      count_neighbor(state, rowidx, colidx, 0, -1) +
      count_neighbor(state, rowidx, colidx, 0, 1) +
      count_neighbor(state, rowidx, colidx, 1, -1) +
      count_neighbor(state, rowidx, colidx, 1, 0) +
      count_neighbor(state, rowidx, colidx, 1, 1)
  end
  
  def new_seat(state, rowidx, colidx)
    current = state[rowidx][colidx]

    return "." if current == "."

    neighbor_count = count_neighbors(state, rowidx, colidx)
    case
    when current == "L" && neighbor_count == 0
      "#"
    when current == "#" && neighbor_count >= 5
      "L"
    else
      current
    end
  end

  def step(state)
    (0..state.length - 1).map do |rowidx|
      row = state[rowidx]
      (0..row.length - 1).map do |colidx|
        new_seat(state, rowidx, colidx)
      end
    end
  end

  def count_occupied(state)
    count = 0
    (0..state.length - 1).each do |rowidx|
      (0..state[rowidx].length - 1).each do |colidx|
        count += 1 if state[rowidx][colidx] == "#"
      end
    end
    count
  end
  
  def exec()
    state = original
    new_state = nil
    while true do
      new_state = step(state)
      break if new_state == state
      state = new_state
    end
    count_occupied(new_state)
  end
end
