#!/usr/bin/env ruby
$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'eldritch'

nums = 20.times.map{ rand(1-10000) }
puts nums