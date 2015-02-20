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

(0..285).each do |i|
	i += 1 #this is the counter we'll use to iterate through the pages
	brandName = [] #this is where we're putting the beer names
	manufacturer = []
	bc = []

	#page.forms shows us that there are 4 forms on the page, unfortunately all with the same name
	#digging around shows that the third has the "post" request relating to page numbers 
	a = page.forms[3] 
	a.field_with(:name => "strPageNum" ).value = #{i} 
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
	puts doc.css('tr td font') gets you the basic info
	#but this is all stored in an array, so we can do 
	c = doc.css('tr td font')
	#Nokogiri sorts these into nodesets, which are great and behave like arrays
	#in our case, or in my limited abilities, they don't behave ENOUGH like arrays though, so we read them into one
	g = []
	c.children.each do |i|
		g << i 	
	end
=begin
so now we can use the "values_at" module. There is almost certainly an easier way to do this
	q = 0
	r = []
	r << 0
	until q == 175
		q += 7
		r << q
	end
but it gets the multiples of 7 up to 75, which lets us pass them (with a splat - *) to values_at as a parameter:

=end
	brand << g.values_at(*r)
	#and from there we'll just do the same for the other 3 values
		
	end	
end

