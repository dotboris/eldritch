#!/usr/bin/env ruby
require 'eldritch'

class BabysFirstClass
  async def foo(arg)
    puts "starting long running task with #{arg}"
    sleep(1)
    puts 'long running task done'
  end
end

obj = BabysFirstClass.new

puts 'calling foo'
obj.foo('stuff')
puts 'doing something else'

# waiting for everyone to stop
(Thread.list - [Thread.current]).each &:join