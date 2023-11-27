# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

results = []
picked = Hash.new(0)

years = ['https://www.lottery.net/pennsylvania/match-6-lotto/numbers/2023',
         'https://www.lottery.net/pennsylvania/match-6-lotto/numbers/2022',
         'https://www.lottery.net/pennsylvania/match-6-lotto/numbers/2021']

years.each do |year|
  doc = Nokogiri::HTML(URI.open(year))
  doc.css('td li').each do |data|
    d = data.content.strip
    results.push(d) if d.to_i != 0
  end
end

draws = []

36.times do |i|
  draws.push(results.shift(6))
  #break if draws[i].length < 5
  #break if draws.flatten.uniq.length >= 49
end

puts "#{draws.length} draws"
puts draws.first.join(', ')

draws.each do |draw|
  draw.each do |pick|
    picked[pick] = picked[pick] + 1
  end
end

latest_draws = draws.shift(6)

latest_draws.each do |draw|
  draw.each do |pick|
    picked.delete_if { |k, v| k == pick }
  end
end

val = picked.values
val.sort!
picked.delete_if { |k, v| v < val.last(6).first }
b = picked.to_a.reverse
picked = b.to_h
h = []
v = picked.values.sort.reverse.uniq

v.each do |x|
  picked.each do |key, value|
    h.push(key) if value == x
  end
end
puts h.first(6).map(&:to_i).sort.join(', ')