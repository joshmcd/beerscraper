#!/usr/bin env ruby

require 'mechanize'
require 'csv'

mechanize = Mechanize.new
url = 'http://www.lcbapps.lcb.state.pa.us/webapp/registered_brands.asp'
page = mechanize.get(url)i

#you may want to edit the path/filename
CSV.open('beer_results.csv', 'w+') do |com|
	com << ["Brand Name", "Manufacturer", "BC" ]
end
	beer_array = [] #this is where we're putting the beer names
	brand = []
	man = []
	bc = []
	q = 0
#there are 287 results. It wouldn't be difficult to alter the query to actually pull the number directly from the page, but I was feeling lazy.

(1..287).each do |x|

	brandInterval = 0
	manInterval = 1
	bcInterval = 2
	a = page.forms[3] 
	a.field_with(:name => "strPageNum" ).value = "#{x}" 
	b = a.submit
	doc = b.parser
	c = doc.css('tr td font')[13..-5]
	g = []
	
	c.children.each do |nodes|
		g << nodes
	end
		until q == 175
			interval = 7
			brand = g.values_at(brandInterval)
			man = g.values_at(manInterval)
			bc = g.values_at(bcInterval)
			beer_array << [brand, man, bc]
			brandInterval += interval
			manInterval += interval
			bcInterval += interval
			q += interval
		end
	q = 0
	end
	
	CSV.open('beer_results.csv', "a+") do |csv|
		beer_array.each do |beer|
	       	csv << beer[0] + beer[1] + beer[2]
	end
end

