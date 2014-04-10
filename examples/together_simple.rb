#!/usr/bin/env ruby
require 'eldritch'

together do
  (1..10).each do |i|
    async { puts i }
  end
end

puts 'all done'