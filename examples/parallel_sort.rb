#!/usr/bin/env ruby
require 'eldritch'

def merge(a, b)
  merged = []

  until b.empty? || a.empty? do
    if a.first <= b.first
      merged += a.take_while { |i| (i <= b.first) }
      a = a.drop_while { |i| i <= b.first }
    else
      merged += b.take_while { |i| i <= a.first }
      b = b.drop_while { |i| i <= a.first }
    end
  end
  merged + (a.empty? ? b : a)
end

def parallel_merge_sort(array)
  return array if array.size <= 1

  mid = (array.length / 2).floor

  first = async { parallel_merge_sort(array.slice(0, mid)) }
  second = parallel_merge_sort(array.slice(mid, array.length - mid))

  merge(second, first.value)
end

nums = (1..25).to_a.shuffle

puts "values: #{nums.join(', ')}"
puts 'sorting...'
sorted = parallel_merge_sort(nums)
puts "values: #{sorted.join(', ')}"
