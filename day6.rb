
message = File.read("./day6_input")

def marker_position(message, length)
  position = nil
  message.size.times.each do |pos|
    buffer = message[pos..pos + length - 1]
    if buffer.split("").uniq.size == length
      position = pos + length
      break
    end
  end

  position
end


p "Number of haracters before first start-of-packet marker: #{marker_position(message, 4)}"

p "Number of haracters before first start-of-message marker: #{marker_position(message, 14)}"
