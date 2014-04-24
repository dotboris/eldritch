#!/usr/bin/env ruby
require 'eldritch'

def merge_sort(array_a, array_b)
  merged_array = []

  while not array_b.empty? and not array_a.empty? do
    if array_a.first <= array_b.first
      merged_array.concat(array_a.take_while { |i| (i <= array_b.first) })
      array_a = array_a.drop_while { |i| i <= array_b.first }
    else
      merged_array.concat(array_b.take_while { |i| i <= array_a.first })
      array_b = array_b.drop_while { |i| i <= array_a.first }
    end
  end
  merged_array.concat(((array_a.empty?) ? array_b : array_a))
  merged_array
end

$threshold = 100

def parallel_sort(array_to_sort)
  if array_to_sort.length < $threshold
    return array_to_sort.sort
  end
  mid_index = (array_to_sort.length / 2).floor

  first_part_task = async { parallel_sort(array_to_sort.slice(0, mid_index)) }
  second_part = parallel_sort(array_to_sort.slice(mid_index, array_to_sort.length - mid_index))

  merge_sort(second_part, first_part_task.value)
end

def not_parallel_sort(array_to_sort)
  if array_to_sort.length < $threshold
    return array_to_sort.sort
  end
  mid_index = (array_to_sort.length / 2).floor

  first_part = not_parallel_sort(array_to_sort.slice(0, mid_index))
  second_part = not_parallel_sort(array_to_sort.slice(mid_index, array_to_sort.length - mid_index))

  merge_sort(second_part, first_part)
end

nums = 1000000.times.map { rand(1..100000) }

start = Time.now
parallel_sort(nums)
mid = Time.now
not_parallel_sort(nums)
stop = Time.now

puts 'Time parallel'
puts mid - start
puts 'Time sequential'
puts stop - mid