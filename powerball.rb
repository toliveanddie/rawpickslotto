# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

doc = Nokogiri::HTML(URI.open('https://www.lotteryusa.com/powerball/year'))

a = ARGV[0].to_i

results = []
picked = Hash.new(0)

doc.css('li').each do |data|
  d = data.content.strip
  results.push(d) if d.to_i != 0
end

draws = []

105.times do |i|
  draws.push(results.shift(5))
  results.shift(1)
  break if draws[i].length < 5

  # break if draws.flatten.uniq.length >= 69
end

puts draws.length

draws.each do |draw|
  draw.each do |pick|
    picked[pick] = picked[pick] + 1
  end
end

latest_draws = draws.shift(a)

latest_draws.each do |draw|
  draw.each do |pick|
    picked.delete_if { |k, _v| k == pick }
  end
end

val = picked.values
val.sort!
picked.delete_if { |_k, v| v < val.last(5).first }
print picked
puts

p = picked.to_a.reverse
picked = p.to_h
h = []
v = picked.values.sort.reverse.uniq

v.each do |x|
  picked.each do |key, value|
    h.push(key) if value == x
  end
end

############## bonus ball ################

bonus = []
doc.css('span').each do |data|
  d = data.content.strip
  bonus.push(d) if d.to_i != 0
end

bonus_ball = Hash.new(0)

bonus.each do |ball|
  bonus_ball[ball] = bonus_ball[ball] + 1
end

valb = bonus_ball.values
valb.sort!

bonus_ball.delete_if { |_ke, va| va < valb.last(8).first }
print bonus_ball
puts
puts h.first(5).map(&:to_i).sort.join(' ')
print 'bonus: '
print bonus_ball.keys.last
puts