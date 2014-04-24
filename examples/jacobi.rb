#!/usr/bin/env ruby
require 'eldritch'

def print_matrix(matrix)
  matrix.each do |line|
    formatted = line.map { |i| '% 10.5f' % i }
    puts "[ #{formatted.join(', ')} ]"
  end
end

matrix = [
  [-1, -1, -1, -1, -1, -1],
  [-1,  1,  2,  3,  4, -1],
  [-1,  1,  2,  3,  4, -1],
  [-1,  1,  2,  3,  4, -1],
  [-1,  1,  2,  3,  4, -1],
  [-1, -1, -1, -1, -1, -1]
]

epsilon = 0.001

print_matrix matrix
puts

matrix_height = matrix.length - 2
matrix_width = matrix[0].length - 2

max_diff = epsilon + 1
iterations = 1
while max_diff > epsilon do
  matrix_temp = Marshal.load(Marshal.dump(matrix))

  together do
    (1..matrix_height).each do |row_id|
      async do
        (1..matrix_width).each do |col_id|
          matrix_temp[row_id][col_id] = [1, -1].product([1, -1])
            .map { |i| matrix[row_id+i[1]][col_id+i[0]] }
            .reduce(:+).to_f / 4
        end
      end
    end
  end

  max_diff = (1..matrix_height).to_a
    .product((1..matrix_width).to_a)
    .map { |i| (matrix_temp[i[0]][i[1]] - matrix[i[0]][i[1]]).abs }
    .max
  matrix = matrix_temp

  puts 'Iteration '
  print_matrix matrix
  puts iterations
  iterations+=1
  puts max_diff
  puts ''
end