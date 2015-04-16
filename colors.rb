RED = "16711680"
DIV = "3335782"
GREEN = "008000"

def get_color( n )
  return GREEN if n > 5
  return RED.to_i.to_s(16) if n < 0
  color = (RED.to_i - ( DIV.to_i * n ) ).to_i.to_s(16)
  check_length(color)
end

def check_length(color)
  diff = 6 - color.length
  if diff > 0
    color.prepend("0" * diff)
  end
  color
end
