#!/usr/bin/env ruby
require 'eldritch'

async def foo
  puts 'starting long running task'
  sleep(1)
  puts 'long running task done'
end

puts 'calling foo'
foo
puts 'doing something else'

# waiting for everybody to stop
(Thread.list - [Thread.current]).each &:join