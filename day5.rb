class Cargo
  attr_reader :stacks

  def initialize(num_stacks)
    @stacks = num_stacks.times.map { [] }
  end

  def peak
    stacks.map(&:last)
  end

  def load_line(line)
    stacks.each_with_index do |stack, i|
      crate = line[i]
      stack.prepend(crate) unless crate == "" || crate.nil?
    end
  end

  def move_stacks(count, from, to)
    origin = stacks[from - 1]
    target = stacks[to - 1]

    crates = origin.pop(count)
    target.push(*crates)
  end
end

cargo = nil

f = File.open("./day5_input", "r")
f.each do |line|
  next if line[0].strip == ""

  if line[0] == "m"
    _, count, _, from, _, to = line.split.map(&:to_i)
    cargo.move_stacks(count, from, to)
    next
  end

  cargo_line = line.split("")
    .each_slice(4)
    .map { |stack| stack.join.strip.gsub(/\W/, "") }

  if cargo.nil?
    cargo = Cargo.new(cargo_line.size)
  end

  cargo.load_line(cargo_line)
end

p "The crates at the top of cargo are #{cargo.peak.join}"