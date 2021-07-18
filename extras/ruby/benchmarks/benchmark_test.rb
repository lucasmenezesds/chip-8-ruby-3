# frozen_string_literal: true

require "benchmark"

sprite = 0x2F
pixel_position = 2
@variable = []
@variable[0xF] = 1

# rubocop:disable Lint/UselessAssignment
def bitwise_op(sprite, pixel_position)
  memory_pixel = (sprite & (1 << (7 - pixel_position))).positive? ? 1 : 0
end

def string_op(sprite, pixel_position)
  memory_pixel = sprite.to_s(2).rjust(8, "0")[pixel_position].to_i
end

def bitwise_op2(memory_pixel, screen_pixel)
  (memory_pixel & screen_pixel) | @variable[0xF]
end

def logical_op(memory_pixel, screen_pixel)
  (memory_pixel && screen_pixel) || @variable[0xF]
end

# rubocop:enable Lint/UselessAssignment

puts " -- bitwise op --"

puts(Benchmark.measure { 1_000_000.times { bitwise_op(sprite, pixel_position) } })

puts "-- string op --"

puts(Benchmark.measure { 1_000_000.times { string_op(sprite, pixel_position) } })

puts "== Benchmark #2 =="

puts "-- bitwise_op2 op --"

puts(Benchmark.measure { 1_000_000.times { bitwise_op2(sprite, pixel_position) } })

puts "-- logical_op op --"

puts(Benchmark.measure { 1_000_000.times { logical_op(sprite, pixel_position) } })
