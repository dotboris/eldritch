#!/usr/bin/env ruby
require 'eldritch'

def print_matrix(matrix)
  matrix.each {|line| puts line.inspect}
end

a = [[1, 2, 3],
     [4, 5, 6]]

b = [[5, 6],
     [7, 8],
     [9, 10]]
b_t = b.transpose

puts 'matrix A:'
print_matrix(a)

puts 'matrix B:'
print_matrix(b)

c = [[0, 0],
     [0, 0]]

together do
  a.each_with_index do |row, y|
    b_t.each_with_index do |col, x|
      async do
        # scalar product
        c[y][x] = row.zip(col).map{|i, j| i*j}.reduce(:+)
      end
    end
  end
end

puts 'A x B = '
print_matrix(c)