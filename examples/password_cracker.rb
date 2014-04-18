#!/usr/bin/env ruby
require 'eldritch'
require 'digest/md5'

if ARGV.size < 2
  puts 'Cracks 4 lowercase letter password hashed using MD5'
  puts
  puts 'usage: password_cracker.rb <threads> <hash>'
  puts '  threads: the number of threads to run'
  puts '  hash: MD5 hash to crack'
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
          group.synchronize { puts password }

          # stop all the other threads
          group.interrupt
          break
        end
      end
    end
  end
end
