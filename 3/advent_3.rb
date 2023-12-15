$file_name = ARGV.first || 'input.txt'

def log(string)
  return if ENV['debug'] != 'true'
  p string
end

def is_special_char?(char)
  return false if char.nil?
  return false if char == '.' || ('0'..'9').cover?(char)
  true
end

def adjacent_special_char?(matrix, i, j)
  special = false

  3.times do |x|
    3.times do |y|
      index_i = i+x - 1
      index_y = j+y - 1

      next if matrix[index_i].nil?

      if is_special_char?(matrix[index_i][index_y])
        log("[#{matrix[index_i][index_y]}] at #{[index_i, index_y]} special: true")
        special = true
        break
      end
      log("[#{matrix[index_i][index_y]}] at #{[index_i, index_y]} special: false")
    end

    break if special
  end

  log("Checking for char #{matrix[i][j]} at #{[i,j]} is special #{special}")
  special
end

matrix = File.readlines($file_name, chomp: true)
engine_numbers = []

matrix.each_with_index do |line, i|
  matches = []
  line.scan(/\d+/) do |m|
    matches << { number: m,  x: i, y: Regexp.last_match.offset(0)[0]  }
  end

  # puts matches.inspect
  # 00, 01, 02
  # 10, 11, 12
  # 20, 21, 22

  # (x-1,y-1), (x-1,  y), (x-1,y+1)
  # (x  ,y-1), (x  ,  y), (x, y+1)
  # (x+1,y-1), (x+1,  y), (x+1,y+1)
  matches.each do |tupple|
    log("-----")
    special = false
    log("match=#{tupple[:number]}")
    tupple[:number].each_char.with_index do |_, digit_pos|
      i = tupple[:x]
      j = tupple[:y] + digit_pos

      if adjacent_special_char?(matrix, i, j)
        special = true
        break
      end
    end
    log("-----")

    engine_numbers << tupple[:number].to_i if special
  end


  log({i: i, matches: matches, engine_numbers: engine_numbers})
end

puts("========================================")
p(engine_numbers)
puts("========================================")

puts engine_numbers.sum # part 1 answer 551094
