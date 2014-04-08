#!/usr/bin/env ruby
require 'eldritch'
include Eldritch::DSL

class BabysFirstClass
  async def foo(arg)
    puts "Hey I got: #{arg}"
    sleep(1)
    puts 'foo done'
  end
end

obj = BabysFirstClass.new

puts 'calling foo'
obj.foo('stuff')
puts 'doing something else'

# waiting for everyone to stop
Thread.list.reject{|t| t == Thread.current}.each &:join