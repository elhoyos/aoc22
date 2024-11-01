require "set"
require "pp"

class Knot
  attr_reader :next_knot, :position, :prev_position

  def initialize(name, position, next_knot = nil)
    @name = name
    @position = position
    @next_knot = next_knot
  end

  def position=(new_position)
    @prev_position = @position
    @position = new_position
  end

  def needs_move?(prev_knot)
    prev_knot_position = prev_knot.position
    h_distance = (prev_knot_position[0] - position[0]).abs
    v_distance = (prev_knot_position[1] - position[1]).abs
    h_distance > 1 || v_distance > 1
  end

  def steps_between(posA, posB)
    step_x = posB[0] - posA[0]
    step_y = posB[1] - posA[1]
    [step_x, step_y]
  end

  def moved_diagonally?(prev_position)
    x, y = steps_between(prev_position, position).map(&:abs)
    x > 0 && y > 0
  end

  def move(prev_knot)
    # prev_position = position
    # binding.pry if prev_position == [4, 4]
    # @position = new_position

    # moved_diagonally = moved_diagonally?(prev_position)

    # if next_knot_needs_move?
    #   if moved_diagonally?(prev_position)
    #     x, y = steps_between(prev_position, position)
    #     next_knot_position = next_knot.position
    #     new_next_knot_position = [next_knot_position[0] + x, next_knot_position[1] + y]
    #   else
    #     new_next_knot_position = prev_position
    #   end

    #   next_knot.move(new_next_knot_position, moved_diagonally)
    # end

    return unless needs_move?(prev_knot)

    @position = prev_knot.prev_position
    @next_knot.move(self)
  end
end

class Rope
  attr_reader :head, :tail, :tail_moves

  def initialize(knots)
    @head = knots.first
    @tail = knots.last
    @tail_moves = Set[tail.position]
  end

  def move_head(dir)
    h_step = 0
    v_step = 0

    case dir
    when "U"
      v_step = 1
    when "R"
      h_step = 1
    when "D"
      v_step = -1
    when "L"
      h_step = -1
    end

    prev_position = head.position
    @head.position = [head.position[0] + h_step, head.position[1] + v_step]
    @head.next_knot.move

    # next_knot = head.next_knot
    # binding.pry if dir == "L"
    # moved_diagonally = head.moved_diagonally?(prev_position)
    # next_knot.move(prev_position, moved_diagonally) if head.next_knot_needs_move?

    tail_moves.add(tail.position)
  end
end

rope_part_1 = Rope.new(
  2.times.each_with_object([]) do |i, ary|
    ary << Knot.new((i + 1 - 2).to_s, [0, 0], ary.last)
  end
  .reverse
)

# rope_part_2 = Rope.new(
#   10.times.each_with_object([]) do |_, ary|
#     ary << Knot.new([0, 0], ary.last)
#   end
#   .reverse
# )

f = File.open("day9_input")
f.each do |line|
  dir, steps = line.split(" ")
  steps.to_i.times.each do
    rope_part_1.move_head(dir)
    # rope_part_2.move(dir)
  end
end

p "(part 1) The tail visited #{rope_part_1.tail_moves.size} positions at least once"

# p "(part 2) The tail visited #{rope_part_2.tail_moves.size} positions at least once"
