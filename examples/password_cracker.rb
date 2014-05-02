#!/usr/bin/env ruby
require 'eldritch'
require 'digest/md5'

if ARGV.size < 2
  puts 'Cracks 4 lowercase letter password hashed using MD5'
  puts
  puts 'usage: password_cracker.rb <threads> <hash>'
  puts '  threads: the number of threads to run'
  puts '  hash: MD5 hash to crack'
  puts
  puts 'example:'
  puts '  password_cracker.rb 4 31d7c3e829be03400641f80b821ef728'
  puts '  prints "butts"'
  exit 1
end

threads = ARGV.shift.to_i
hash = ARGV.shift

# generate all possible 4 lowercase letter passwords
passwords = ('a'..'z').to_a.repeated_permutation(4).lazy.map &:join

together do |group|
  # cut the passwords into slices
  passwords.each_slice(passwords.size/threads) do |slice|
    async do
      slice.each do |password|
        if hash == Digest::MD5.hexdigest(password)
          group.synchronize do
            puts password

            # stop the other tasks
            group.interrupt
            break
          end
        end
      end
    end
  end
end
