require "set"

class Journey
  attr_reader :head, :tail, :tail_journey

  def initialize
    @head = [0, 0]
    @tail = head.clone
    @tail_journey = Set[tail]
  end

  def move_tail?
    h_distance = (head[0] - tail[0]).abs
    v_distance = (head[1] - tail[1]).abs
    h_distance > 1 || v_distance > 1
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

    prev_head = head

    @head = [head[0] + h_step, head[1] + v_step]
    @tail = prev_head if move_tail?

    tail_journey.add(tail)
  end
end

journey = Journey.new

f = File.open("day9_input")
f.each do |line|
  dir, steps = line.split(" ")
  steps.to_i.times.each { |_| journey.move(dir) }
end

p "The tail visited #{journey.tail_journey.size} positions at least once"