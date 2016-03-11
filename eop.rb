#!/usr/bin/env ruby

require 'net/http'
require 'uri'
require 'nokogiri'

uri           = URI.parse(ARGV.first)
response      = Net::HTTP.get_response(uri)
doc           = Nokogiri::HTML(response.body)
user_images   = []
four_oh_fours = []
redirects     = []

puts "Analysing #{uri} now...\n"

doc.css('.user-html img').map do |image|
  user_images << image.attributes['src'].value
end

user_images.each do |image|
  response = Net::HTTP.get_response(URI.parse(image))
  redirects << image if response.code.start_with? '3'
  four_oh_fours << image if response.code == '404'
end

puts "- Detected #{four_oh_fours.size} 404's.\n" +
     "- Detected #{redirects.size} redirects\n"

