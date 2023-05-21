# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

results = []
picked = Hash.new(0)

doc = Nokogiri::HTML(URI.open('https://www.lotteryusa.com/pennsylvania/match-6/year'))

doc.css('li').each do |data|
  d = data.content.strip
  results.push(d) if d.to_i != 0
end

draws = []

55.times do |i|
  draws.push(results.shift(6))
  break if draws[i].length < 6
  # break if draws.flatten.uniq.length >= 49
end

puts draws.length

draws.each do |draw|
  draw.each do |pick|
    picked[pick] = picked[pick] + 1
  end
end

latest_draws = draws.shift(ARGV[0].to_i)

latest_draws.each do |draw|
  draw.each do |pick|
    picked.delete_if { |k, v| k == pick }
  end
end

val = picked.values
val.sort!
picked.delete_if { |k, v| v < val.last(6).first }
print picked
puts
puts
b = picked.to_a.reverse
picked = b.to_h
h = []
v = picked.values.sort.reverse.uniq

v.each do |x|
  picked.each do |key, value|
    h.push(key) if value == x
  end
end
puts h.first(6).map(&:to_i).sort.join(' ')