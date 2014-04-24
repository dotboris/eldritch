#!/usr/bin/env ruby
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'eldritch'
require 'pp' #pretty print

matrix_example = [
  [-1, -1, -1, -1, -1, -1],
  [-1,  1,  2,  3,  4, -1],
  [-1,  1,  2,  3,  4, -1],
  [-1,  1,  2,  3,  4, -1],
  [-1,  1,  2,  3,  4, -1],
  [-1, -1, -1, -1, -1, -1]]

$epsilon = 0.001
def jacobi(matrix)
  pp matrix
  puts ''

  matrix_height = matrix.length - 2
  matrix_width = matrix[0].length - 2

  maxDiff = $epsilon + 1
  iterations = 1
  while maxDiff > $epsilon do
    matrix_temp = Marshal.load( Marshal.dump(matrix) )

    together do |group|
      ( 1..matrix_height ).each do |row_id|
        async do
          ( 1..matrix_width ).each do |col_id|
            matrix_temp[row_id][col_id] = [1, -1].product( [1,-1] )
                                                 .map{ |i| matrix[row_id+i[1]][col_id+i[0]] }
                                                 .reduce(:+).to_f / 4
          end
        end
      end
    end

    maxDiff = (1..matrix_height).to_a
                                .product((1..matrix_width).to_a)
                                .map{ |i| (matrix_temp[i[0]][i[1]] - matrix[i[0]][i[1]]).abs }
                                .max
    matrix = matrix_temp

    print 'Iteration '
    pp matrix
    puts iterations
    iterations+=1
    pp maxDiff
    puts ''
  end
end

jacobi(matrix_example)