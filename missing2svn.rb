#!/usr/bin/env ruby
# Use this script to add/delete all files that are showing ! or ? in svn st

com = ARGV.first
sym = "!"

if com == "del"
  sym="!"
else
  sym="?"
end

puts "svn status | grep '#{sym}'" #.gsub(/\![^\w]*/,"").split("\n").each { |f| `svn #{com} #{f}`}

