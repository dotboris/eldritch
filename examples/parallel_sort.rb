#!/usr/bin/env ruby
require 'eldritch'

def merge_sort(a, b)
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

$threshold = 100

def parallel_sort(array)
  if array.length < $threshold
    return array.sort
  end
  mid = (array.length / 2).floor

  first = async { parallel_sort(array.slice(0, mid)) }
  second = parallel_sort(array.slice(mid, array.length - mid))

  merge_sort(second, first.value)
end

def not_parallel_sort(array)
  if array.length < $threshold
    return array.sort
  end
  mid = (array.length / 2).floor

  first = not_parallel_sort(array.slice(0, mid))
  second = not_parallel_sort(array.slice(mid, array.length - mid))

  merge_sort(second, first)
end

nums = 100000.times.map { rand(1..100000) }

start = Time.now
parallel_sort(nums)
mid = Time.now
not_parallel_sort(nums)
stop = Time.now

puts 'Time parallel'
puts mid - start
puts 'Time sequential'
puts stop - mid