#!/usr/bin/env ruby
require 'eldritch'
include Eldritch::DSL

async def foo
  puts "running foo"
end

foo
sleep(1)
puts "hello"