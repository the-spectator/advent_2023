$file_name = ARGV.first || 'input.txt'


def get_game_id_and_stats(line)
  game_id, stats = line.split(":")
  game_id = game_id.match(/(?<game_id>\d+)/)[:game_id].to_i
  [game_id, stats]
end

def get_colour_count(col_pair_string)
  match = col_pair_string.match(/(?<count>\d+)\s*(?<color>\w+)/)
  count = match[:count].to_i
  color = match[:color]
  [color, count]
end


def part_1
  max = { "red" => 12, "green" => 13, "blue" => 14 }

  sum = 0

  File.readlines($file_name, chomp: true).each do |line|
    game_id, stats = get_game_id_and_stats(line)
    possible = true
    stats.strip.split(";").each do |try|
      try.strip.split(",").each do |col_pair|
        match = col_pair.match(/(?<count>\d+)\s*(?<color>\w+)/)
        count = match[:count].to_i
        color = match[:color]
        if count > max[color]
          possible = false
          break
        end
      end
    end

    if possible
      sum += game_id
    end
  end

  puts "Part 1 solution: #{sum}"

  sum
end



def part_2
  sum = 0

  File.readlines($file_name, chomp: true).each do |line|
    game_id, stats = get_game_id_and_stats(line)
    max = { "red" => 0, "green" => 0, "blue" => 0 }

    stats.strip.split(";").each do |try|
      try.strip.split(",").each do |col_pair_string|
        colour, count = get_colour_count(col_pair_string)
        max[colour] = [count, max[colour]].max
      end
    end

    product = max.values.inject(:*)
    sum += product
  end

  puts "Part 2 solution: #{sum}"
end


part_1
part_2
