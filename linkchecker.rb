#!/usr/bin/env ruby
require 'net/http'
require 'csv'

# Parse the output of Google webmasters tools csv data to see if the response codes have changed

domain="www.example.com"

parsed_file=CSV::Reader.parse(File.open('csv.csv', 'r'))

parsed_file.each do |row|
  url = row[0].gsub('http://#{domain}',"")
  resp=""
  Net::HTTP.start(domain) { |http|
    resp=http.get(url)
  }
  p resp.code << " : " << url 
end
