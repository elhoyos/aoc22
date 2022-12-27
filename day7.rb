class Directory
  attr_reader :name, :parent, :directories, :files

  def initialize(name, parent = nil)
    @name = name
    @parent = parent
    @directories = []
    @files = []
  end

  def add_dir(directory)
    @directories << directory
  end

  def add_file(file)
    @files << file
  end

  def all_directories
    directories + directories.map(&:all_directories).flatten
  end

  def total_size
    files.sum(&:size) + directories.sum(&:total_size)
  end
end

class LameFile
  attr_reader :name, :size

  def initialize(name, size)
    @name = name
    @size = size
  end
end

root = Directory.new("/")
cwd = nil

f = File.open("day7_input", "r")
f.each do |line|
  case line.strip
  when "$ cd /"
    cwd = root
  when "$ cd .."
    cwd = cwd.parent
  when /cd (.+)/
    cwd = cwd.directories.find { |dir| $1 == dir.name }
    raise "Couldn't find a directory named #{$1} in #{cwd.name}" if cwd.nil?
  when "$ ls"
    nil
  when /^dir (.+)/
    cwd.add_dir(Directory.new($1, cwd))
  when /^(\d+) (.+)/
    cwd.add_file(LameFile.new($2, $1.to_i))
  else
    raise "Unknown command/output: #{line.strip}"
  end
end

all_directories = [root] + root.all_directories

result = all_directories.filter do |directory|
  directory.total_size <= 100_000
end

p "The sum of the total size of big directories is #{result.sum(&:total_size)}"

total_disk = 70_000_000
update_needs = 30_000_000
space_needed = update_needs - (total_disk - root.total_size)

total_size = all_directories.map(&:total_size).sort.find do |total_size|
  total_size >= space_needed
end

p "The total size of the directory to delete is #{total_size}"