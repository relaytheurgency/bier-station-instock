#!/usr/bin/ruby

require 'open-uri'
require 'nokogiri'

# Grab first page
doc = Nokogiri::HTML(URI.open("https://carttocar.com/bier-station/"))
# Get last page number
lastpage = doc.css("li a.page-numbers")[-2].content

# Build inventory of all the pages
puts "Building inventory of pages: " + Time.now.getutc.to_s
pages = []
(1..lastpage.to_i).each do |n|
  pages << Nokogiri::HTML(URI.open("https://carttocar.com/bier-station/?product-page=#{n}"))
end
puts "Finished inventory of pages: " + Time.now.getutc.to_s

puts "Filtering to only in stock beers: " + Time.now.getutc.to_s
# Get only the in stock beers
instock_beers = []
pages.each do |page|
  page.css("li.instock").each do |instock|
    instock_beers << instock
    #puts instock.css("span")[-2].content
  end
end
puts "Finished filtering to only in stock beers: " + Time.now.getutc.to_s

puts "Buiding array of results: " + Time.now.getutc.to_s
# Filter down to only the in stock beers that you care about
beer_results = []
instock_beers.each do |beer|
  beer_link = beer.css("a").attr("href").to_s
  if (beer.attr("class").match?(/ipa|sour|stout/) && !beer_link.to_s.end_with?("single/"))
    beer_results << beer_link + "\t" + beer.css("span.price")[-1].content.to_s + "\nDescription: " + Nokogiri::HTML(URI.open(beer_link)).xpath('/html/body/div[1]/div/div/div/div[3]/div/div/div[2]/div[2]/div[2]/div/p').text.to_s
  end
end
puts "Finished building array of results: " + Time.now.getutc.to_s

puts beer_results.uniq
