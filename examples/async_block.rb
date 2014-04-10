#!/usr/bin/env ruby
require 'eldritch'

async do
  puts 'starting long running task'
  sleep(1)
  puts 'long running task done'
end

puts 'doing something else'

# waiting for everyone to finish
(Thread.list - [Thread.current]).each &:join