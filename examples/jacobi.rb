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

height = matrix.length - 2
width = matrix[0].length - 2

iterations = 1
begin
  matrix_temp = Marshal.load(Marshal.dump(matrix))

  together do
    (1..height).each do |row_id|
      async do
        (1..width).each do |col_id|
          neighbors = [col_id - 1, col_id + 1].product([row_id - 1, row_id + 1]).map{|i, j| matrix[i][j]}
          matrix_temp[row_id][col_id] = neighbors.reduce(:+) / 4.0
        end
      end
    end
  end

  max_diff = (1..height).to_a
    .product((1..width).to_a)
    .map { |i| (matrix_temp[i[0]][i[1]] - matrix[i[0]][i[1]]).abs }
    .max
  matrix = matrix_temp

  print_matrix matrix
  puts "iteration = #{iterations}; diff = #{max_diff}"
  puts

  iterations+=1
end while max_diff > epsilon