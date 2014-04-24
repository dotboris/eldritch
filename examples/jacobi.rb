#!/usr/bin/env ruby
require 'eldritch'

def print_matrix(matrix)
  matrix.each do |line|
    formatted = line.map { |i| '% 10.5f' % i }
    puts "[ #{formatted.join(', ')} ]"
  end
end

def create_matrix(n, m)
  Array.new(n+2).map{[-1] * (m+2)}
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
width = matrix.first.length - 2

iteration = 1
begin
  next_matrix = create_matrix(height, width)

  together do
    (1..height).each do |r|
      async do
        (1..width).each do |c|
          neighbors = [c-1, c+1].product([r-1, r+1]).map{|i, j| matrix[i][j]}
          next_matrix[r][c] = neighbors.reduce(:+) / 4.0
        end
      end
    end
  end

  diff = matrix.flatten.zip(next_matrix.flatten).map{|i, j| (i - j).abs}.max

  matrix = next_matrix

  print_matrix matrix
  puts "iteration = #{iteration}; diff = #{diff}"
  puts

  iteration += 1
end while diff > epsilon