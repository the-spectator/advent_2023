sum = 0

number_words = {
  'one' => 1,
  'two' => 2,
  'three' => 3,
  'four' => 4,
  'five' => 5,
  'six' => 6,
  'seven' => 7,
  'eight' => 8,
  'nine' => 9,
  '1' => 1,
  '2' => 2,
  '3' => 3,
  '4' => 4,
  '5' => 5,
  '6' => 6,
  '7' => 7,
  '8' => 8,
  '9' => 9
}

regex = /(?=(nine|eight|seven|six|five|four|three|two|one|\d))/
file_name = ARGV.first || 'input.txt'

File.readlines(file_name, chomp: true).each do |line|
  matches = line.scan(regex)
  answer = "#{number_words[matches[0][0]]}#{number_words[matches[-1][0]]}".to_i
  puts "line: #{line}, matches: #{matches}, answer: #{answer}"
  sum += answer
end

puts sum
