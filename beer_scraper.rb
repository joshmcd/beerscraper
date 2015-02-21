require 'mechanize'
require 'csv'

mechanize = Mechanize.new
url = 'http://www.lcbapps.lcb.state.pa.us/webapp/registered_brands.asp'
page = mechanize.get(url)

CSV.open('C:\Users\jmcdon39\Desktop\beer.csv')
	csv << ["Brand Name", "Manufacturer", "BC" ]
end

#this is just to demonstrate isolating the needed data
page.search('tr td font')[13..-5].each do |data|
	puts data.inner_text
end

#there are 286 records
	beer = [] #this is where we're putting the beer names
	brand = []
	man = []
	bc = []
	brandInterval = 0
	manInterval = 1
	bcInterval = 2
(0..285).each do |i|
	i += 1 #this is the counter we'll use to iterate through the pages
	
	#page.forms shows us that there are 4 forms on the page, unfortunately all with the same name
	#digging around shows that the third has the "post" request relating to page numbers 
	a = page.forms[3] 
	a.field_with(:name => "strPageNum" ).value = "#{i}" 
	b = a.submit
=begin
	#one way to get the data is with .gsub and a regex:
		b[13..-5].each do |beer|
			puts beer.inner_text
		end
	#but parsing html with regex is famously not the best way to deal, so we should use 
	#nokogiri to parse it instead:
=end
	doc = b.parser
#the xpath of an element chosen at random is //*[@id="pt-portal-content-613684"]/table[2]/tbody/tr[2]/td/table[3]/tbody/tr[27]/td[3]/font
#but I find CSS selectors easier to use, especially because I don't find xml super-intuitive
	#puts doc.css('tr td font') gets you the basic info
	#but this is all stored in an array, so we can do 
	c = doc.css('tr td font')[13..-5]
	#Nokogiri sorts these into nodesets, which are great and behave like arrays
	#in our case--or in my limited abilities--they don't behave ENOUGH like arrays though, so we read them into one
	g = []
	c.children.each do |i|
		g << i 	
	end
	#we've already got the "i" value in the each iteration. The values we need are seven lines apart, so:
	q = i
	r = 175 + i
	until q == r
		brandInterval += q
		manInterval += q
		bcInterval += q
		beer << g.values_at(brandInterval, manInterval, bcInterval)
		q += 7
	end
end


=begin
#so we can use the "values_at" module. There is almost certainly an easier way to do this, with Enumerable for instance, but:
	q = 0
	brandInterval = []
	brandInterval << 0
	until q == 175
		q += 7
		brandInterval << q
	end
#gets the multiples of 7 up to 75, which lets us pass them (with a splat - *) to values_at as a parameter:
	brand << g.values_at(*brandInterval)
	
	#and from there we'll just do the same for the other 3 values
	q = 1
	manInterval = []
	manInterval << 1
		until q == 176
		q +=7
		manInterval << q
	end	
	man << g.values_at(*manInterval)
	
	q = 2
	bcInterval = []
	bcInterval << 2
		until q == 177
		q +=7
		bcInterval << q
	end	
	bc << g.values_at(*bcInterval)

		#all this logic could almost certainly be better; maybe we can loop through? or map them to each other?
		#this doesn't really get the data arranged the way we need it
		
=end	
