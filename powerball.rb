# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

yearpages = ['https://www.lottery.net/powerball/numbers/2023', 'https://www.lottery.net/powerball/numbers/2022']

results = []
bonus = []
picked = Hash.new(0)

yearpages.each do |year|
  doc = Nokogiri::HTML(URI.open(year))
  doc.css('td li').each do |data|
    d = data.content.strip
    results.push(d) if d.to_i != 0
  end
end

draws = []

500.times do |i|
  draws.push(results.shift(5))
  if (i+1).odd?
    bonus.push(results.shift(1))
    results.shift(1)
  else
    bonus.push(results.shift(1))
  end
  #break if draws.flatten.uniq.length >= 69
end

puts draws.length

draws.each do |draw|
  draw.each do |pick|
    picked[pick] = picked[pick] + 1
  end
end

latest_draws = draws.shift(13)

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

bonus.flatten!
bonus_ball = Hash.new(0)

bonus.each do |ball|
  bonus_ball[ball] = bonus_ball[ball] + 1
  break if bonus_ball.values.length >= 26
end

valb = bonus_ball.values
valb.sort!

bonus_ball.delete_if { |_ke, va| va < valb.last(8).first }
print bonus_ball
puts
puts h.first(5).map(&:to_i).sort.join(', ')
print 'bonus: '
print bonus_ball.keys.last
puts