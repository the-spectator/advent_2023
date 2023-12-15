$file_name = ARGV.first || 'input.txt'

def log(string)
  return if ENV['debug'] != 'true'
  p string
end


class PartOne
  private attr_reader :matrix, :engine_numbers

  def initialize
    @matrix = File.readlines($file_name, chomp: true)
    @engine_numbers = []
  end

  def solve!
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

    engine_numbers
  end

  private

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

  def is_special_char?(char)
    return false if char.nil?
    return false if char == '.' || ('0'..'9').cover?(char)
    true
  end
end

class PartTwo

  private attr_reader :matrix, :engine_numbers, :star_map

  def initialize
    @matrix = File.readlines($file_name, chomp: true)
    @engine_numbers = []
    @star_map = {}
  end

  def solve!
    matrix.each_with_index do |line, i|
      matches = []
      line.scan(/\d+/) do |m|
        matches << { number: m,  x: i, y: Regexp.last_match.offset(0)[0]  }
      end

      matches.each do |tupple|
        log("-----")
        special = false
        special_tupple = {}

        log("match=#{tupple[:number]}")
        tupple[:number].each_char.with_index do |_, digit_pos|
          i = tupple[:x]
          j = tupple[:y] + digit_pos

          special_tupple = adjacent_special_char?(matrix, i, j)

          if special_tupple[:found]
            special = true
            break
          end
        end
        log("-----")

        if star?(special_tupple[:special_char])
          log("found star at #{special_tupple[:special_char_pos]}")
          star_map[special_tupple[:special_char_pos]] ||= []
          star_map[special_tupple[:special_char_pos]] << tupple[:number].to_i
        end

        engine_numbers << tupple[:number].to_i if special
      end


      log({i: i, matches: matches, engine_numbers: engine_numbers, star_map: star_map})
    end

    gears = star_map.filter_map do |k, v|
      v.size == 2 ? v.inject(:*) : nil
    end

    gears
  end

  private

  def adjacent_special_char?(matrix, i, j)
    special = { found: false, special_char: nil, special_char_pos: nil }

    3.times do |x|
      3.times do |y|
        index_i = i+x - 1
        index_y = j+y - 1

        next if matrix[index_i].nil?

        if is_special_char?(matrix[index_i][index_y])
          special = { found: true, special_char: matrix[index_i][index_y], special_char_pos: [index_i, index_y] }
          log("[#{matrix[index_i][index_y]}] at #{[index_i, index_y]} special: #{special}")
          break
        end
        log("[#{matrix[index_i][index_y]}] at #{[index_i, index_y]} special: false")
      end

      break if special[:found]
    end

    log("Checking for char #{matrix[i][j]} at #{[i,j]} is special #{special}")
    special
  end

  def is_special_char?(char)
    return false if char.nil?
    return false if char == '.' || ('0'..'9').cover?(char)
    true
  end

  def star?(char)
    char == '*'
  end
end


if ENV['part_one']
  puts("=============Part 1=======================")
  engine_numbers = PartOne.new.solve!
  p(engine_numbers)
  puts engine_numbers.sum # part 1 answer 551094
  puts("===================--=====================")
end


puts("=============Part 2=======================")
gear_ratios = PartTwo.new.solve!
p(gear_ratios)
puts gear_ratios.sum # part 1 answer 551094
puts("===================--=====================")
