#!/usr/bin/env ruby
# find all packages installed as deps that are orphaned
`pacman -Qdt`.each do |package|
  # and remove them (but not their deps)
  `sudo pacman -R #{package.gsub(/ .*/, "")}`
end
