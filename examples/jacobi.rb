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
          neighbors = [col_id - 1, col_id + 1].product([row_id - 1, row_id + 1]).map{|i, j| matrix[i][j]}
          matrix_temp[row_id][col_id] = neighbors.reduce(:+) / 4.0
        end
      end
    end
  end

  max_diff = (1..matrix_height).to_a
    .product((1..matrix_width).to_a)
    .map { |i| (matrix_temp[i[0]][i[1]] - matrix[i[0]][i[1]]).abs }
    .max
  matrix = matrix_temp

  print_matrix matrix
  puts "iteration = #{iterations}; diff = #{max_diff}"
  puts
  iterations+=1
end