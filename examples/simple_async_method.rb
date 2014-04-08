#!/usr/bin/env ruby
require 'eldritch'
include Eldritch::DSL

async def foo
  puts 'started foo'
  sleep(1)
  puts 'finished foo'
end

puts 'calling foo'
foo
puts 'doing something else'

# waiting for everybody to stop
(Thread.list - [Thread.current]).each &:join