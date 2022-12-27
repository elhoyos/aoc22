

count_ranges_contained = 0
count_ranges_overlap = 0

f = File.open("./day4_input", "r")
f.each do |line|
  sectionA, sectionB = line.strip.split(",")
    .map do |range_str|
      Range.new(*range_str.split("-").map(&:to_i))
    end

  if sectionA.cover?(sectionB) || sectionB.cover?(sectionA)
    count_ranges_contained += 1
  end

  if sectionA.cover?(sectionB.first) || sectionB.cover?(sectionA.first)
    count_ranges_overlap += 1
  end
end

p "Assignment pair ranges fully contained in the other #{count_ranges_contained}"

p "Assignment pair ranges that overlap: #{count_ranges_overlap}"