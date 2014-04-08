#!/usr/bin/env ruby
require 'eldritch'
include Eldritch::DSL

class BabysFirstClass
  async def foo(arg)
    puts "Hey I got: #{arg}"
  end
end

obj = BabysFirstClass.new
obj.foo('stuff')
sleep(1)
puts 'done'