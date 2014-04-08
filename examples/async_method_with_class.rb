#!/usr/bin/env ruby
require 'eldritch'
include Eldritch::DSL

class BabysFirstClass
  async def foo(arg)
    puts "starting long running task with #{stuff}"
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