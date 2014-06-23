require 'csv'
require 'mechanize'

a = Mechanize.new
input_csv = "ebay_GB_US_source_100.csv"


CSV.foreach(input_csv, :headers => true) do |row|

	file_name = row["url"]
	id = row["id"]
	page = a.get("http://www.bhp.ebay.com/bhp/#{file_name}")
	puts file_name
	file = File.open("#{id}-#{file_name}.html", "wb")
	file.write(page.content)

end
