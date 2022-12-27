require "set"
require "pp"

class Knot
  attr_accessor :position

  attr_reader :next_knot

  def initialize(position, next_knot = nil)
    @position = position
    @next_knot = next_knot
  end

  def next_knot_needs_move?
    return false unless next_knot

    next_knot_position = next_knot.position
    h_distance = (next_knot_position[0] - position[0]).abs
    v_distance = (next_knot_position[1] - position[1]).abs
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

  def move(new_position, prev_moved_diagonally)
    prev_position = position
    binding.pry if prev_position == [4, 4]
    @position = new_position

    moved_diagonally = moved_diagonally?(prev_position)

    if next_knot_needs_move?
      if moved_diagonally?(prev_position)
        x, y = steps_between(prev_position, position)
        next_knot_position = next_knot.position
        new_next_knot_position = [next_knot_position[0] + x, next_knot_position[1] + y]
      else
        new_next_knot_position = prev_position
      end

      next_knot.move(new_next_knot_position, moved_diagonally)
    end
  end
end

class Journey
  attr_reader :head, :tail, :tail_journey

  def initialize(knots)
    @head = knots.first
    @tail = knots.last
    @tail_journey = Set[tail.position]
  end

  def move(dir)
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
    next_knot = head.next_knot
    binding.pry if dir == "L"
    moved_diagonally = head.moved_diagonally?(prev_position)
    next_knot.move(prev_position, moved_diagonally) if head.next_knot_needs_move?

    tail_journey.add(tail.position)
  end
end

# journey_part_1 = Journey.new(
#   2.times.each_with_object([]) do |_, ary|
#     ary << Knot.new([0, 0], ary.last)
#   end
#   .reverse
# )

journey_part_2 = Journey.new(
  10.times.each_with_object([]) do |_, ary|
    ary << Knot.new([0, 0], ary.last)
  end
  .reverse
)

f = File.open("day9_p2_sample_input")
f.each do |line|
  dir, steps = line.split(" ")
  steps.to_i.times.each do
    # journey_part_1.move(dir)
    journey_part_2.move(dir)
  end
end

# p "(part 1) The tail visited #{journey_part_1.tail_journey.size} positions at least once"

p "(part 2) The tail visited #{journey_part_2.tail_journey.size} positions at least once"

pp journey_part_2.head