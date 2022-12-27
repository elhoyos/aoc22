lines = File.readlines("day8_input")
@grid = lines.map do |line|
  new_line = line.split("").map(&:to_i)
  new_line.pop
  new_line
end

@grid_tx = @grid.transpose
@size = @grid[0].size - 1

def visible?(tree)
  i, j, height = tree
  up, right, down, left = [
    i == 0     ? [-1] : [@grid_tx[j][0..i-1].max],
    j == @size ? [-1] : [@grid[i][j+1..].max],
    i == @size ? [-1] : [@grid_tx[j][i+1..].max],
    j == 0     ? [-1] : [@grid[i][0..j-1].max],
  ]

  (up + right + down + left).any? { |other| height > other }
end

def score(tree)
  i, j, height = tree

  def visible_count(heights, height)
    count = heights.take_while { |other| height > other }.count
    count += 1 if count != heights.count
    count
  end

  up, right, down, left = [
    i == 0     ? 0 : visible_count(@grid_tx[j][0..i-1].reverse, height),
    j == @size ? 0 : visible_count(@grid[i][j+1..], height),
    i == @size ? 0 : visible_count(@grid_tx[j][i+1..], height),
    j == 0     ? 0 : visible_count(@grid[i][0..j-1].reverse, height),
  ]

  up * right * down * left
end

visible_trees = []
scenic_scores = []
@grid.each_with_index do |row, i|
  row.each_with_index do |height, j|
    tree = [i, j, height]
    visible_trees << tree if visible?(tree)
    scenic_scores << score(tree)
  end
end

p "Number of visible trees #{visible_trees.size}"

p "The highest scenic score possible is #{scenic_scores.max}"