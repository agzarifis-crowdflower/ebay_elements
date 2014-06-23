require 'csv'
require 'highline/import'
require 'hpricot'

file_name = ARGV[0]
files = Dir.glob("*.html")
if file_name == nil
	say "You did not specify which file you want to modify. One will be selected from the folder at random."
	file_name = "random"
end
if file_name == "random"	
	num_files = files.length
	rand_num = rand(0..(num_files - 1))
	file_name = files[rand_num]
	puts file_name
end
while (!files.include?(file_name))
	file_name = ask "The file name you specified could not be found in this folder, either specify a correct file name now or type 'random' and one will be selected from the folder at random."
	if file_name == "random"	
		num_files = files.length
		rand_num = rand(0..(num_files - 1))
		file_name = files[rand_num]
		puts file_name
	end
end
original = File.read(file_name)
text = File.read(file_name)

##-Pyrite Tips-##
tips = []
a1 = "Page Name"
a2 = "Top Navigation"
a3 = "Side Suggestions"
a4 = "Top 3 Grid"
a5 = "Left Browse Related"
a6 = "First Item in Results"
a7 = "Also Shop In"
a8 = "Rest of Results"
a9 = "Collections You Might Like"
a10 = "Recommended Buying Guides"
a11 = "Bottom Browse Related"


new_id = rand(10000..999999).to_s
new_file_name = file_name.gsub(/^\d+/, new_id)
file_url_name = file_name.match(/-(.+).html/)[1]
tracking = "ebay_gold_tracking.csv"

a = "y"

t = ask "Would you like to view the original page? y/n"
if t == "y"
	`open #{file_name}`
end

while a == "y"
	e = ask "\n 	<%= color('Which', BOLD) %> <%= color('element', RED, BOLD) %> <%= color('would you like to edit?', BOLD) %>
				<%= color('Input - Result:', BOLD) %>
				<%= color('1 - Page Name', RED, BOLD) %>
				<%= color('2 - Top Navigation', RED, BOLD) %>
				<%= color('3 - Side Suggestions', RED, BOLD) %>
				<%= color('4 - Top 3 Grid', RED, BOLD) %>
				<%= color('5 - Left Browse Related', RED, BOLD) %>
				<%= color('6 - First Item in Results', RED, BOLD) %>
				<%= color('7 - Also Shop In', RED, BOLD) %>
				<%= color('8 - Rest of Results', RED, BOLD) %>
				<%= color('9 - Collections You Might Like', RED, BOLD) %>
				<%= color('10 - Recommended Buying Guides', RED, BOLD) %>
				<%= color('11 - Bottom Browse Related', RED, BOLD) %>
				<%= color('RESET - Revert back to the Original File', BOLD) %>"

	if e == "1"
		say "You are editing <%= color('1 - Page Name', RED, BOLD) %>"

		grab = text.match(/<h1>(.*)<\/h1>/)
		grab = grab[1]
		say "The current Page Name:
		#{grab}"
		c = ask "Would you like to make a change? y/n"
		if c == "y"
			input = ask "What would you like to change the Page Name to?"
			text = text.sub(/<h1>.*<\/h1>/, "<h1>#{input}</h1>")
			gold = File.open("#{new_file_name}", "wb")
			gold.write(text)
			p = ask "Would you like to view your changes? y/n"
			if p == "y"
				`open #{new_file_name}`
			end
			tips << a1
		end
	end

	if e == "2"
		say "You are editing <%= color('2 - Top Navigation', RED, BOLD) %>"
		doc = Hpricot(text)
		el = doc/"#bc .thrd"
		say "The current Top Navigation links:\nInput - Result"
		for i in (0..(el.length-1))
			say "#{i} - #{el[i].inner_html}"
		end
		c = ask "Would you like to make a change? y/n"
		while c == "y"
			d = ask "Which Top Navigation link would you like to change?"
			d = d.to_i
			say "The current link text:
			#{el[d].inner_html}"
			input = ask "What would you like to change this link to?"
			el[d].inner_html = input
			text = doc.inner_html
			gold = File.open("#{new_file_name}", "wb")
			gold.write(text)		
			p = ask "Would you like to view your changes? y/n"
			if p == "y"
				`open #{new_file_name}`
			end
			c = ask "Would you like to change another Top Navigation link? y/n"
			tips << a2
		end	
	end

	if e == "3"
		say "You are editing <%= color('3 - Side Suggestions', RED, BOLD) %>"
		doc = Hpricot(text)
		el = doc/"#ChildItems a"
		if el.empty?
			say "<%= color('There are no Side Suggestions on this page.', RED, BOLD) %>"
			redo
		end
		say "The current Side Suggestion links:\nInput - Result"
		for i in (0..(el.length-1))
			say "#{i} - #{el[i].inner_html}"
		end
		c = ask "Would you like to make a change? y/n"
		while c == "y"
			d = ask "Which Side Suggestion link would you like to change?"
			d = d.to_i
			say "The current link text:
			#{el[d].inner_html}"
			input = ask "What would you like to change this link to?"
			el[d].inner_html = input
			text = doc.inner_html
			gold = File.open("#{new_file_name}", "wb")
			gold.write(text)		
			p = ask "Would you like to view your changes? y/n"
			if p == "y"
				`open #{new_file_name}`
			end
			c = ask "Would you like to change another Side Suggestion link? y/n"
			tips << a3
		end	
	end

	if e == "4"
		say "You are editing <%= color('4 - Top 3 Grid', RED, BOLD) %>"
		doc = Hpricot(text)
		el = doc/"#TopPilePanel .bw-ttl a"
		if el.empty?
			say "<%= color('There is no Top 3 Grid on this page.', RED, BOLD) %>"
			redo
		end
		say "The current Top 3 Grid links:\nInput - Result"
		for i in (0..(el.length-1))
			say "#{i} - #{el[i].inner_html}"
		end
		c = ask "Would you like to make a change? y/n"
		while c == "y"
			d = ask "Which Top 3 Grid link would you like to change?"
			d = d.to_i
			say "The current link text:
			#{el[d].inner_html}"
			input = ask "What would you like to change this link to?"
			el[d].inner_html = input
			text = doc.inner_html
			gold = File.open("#{new_file_name}", "wb")
			gold.write(text)		
			p = ask "Would you like to view your changes? y/n"
			if p == "y"
				`open #{new_file_name}`
			end
			c = ask "Would you like to change another Top 3 Grid link? y/n"
			tips << a4
		end	
	end

	if e == "5"
		say "You are editing <%= color('5 - Left Browse Related', RED, BOLD) %>"
		doc = Hpricot(text)
		el = doc/"#RelatedItems a"
		if el.empty?
			say "<%= color('There is no Left Browse Related on this page.', RED, BOLD) %>"
			redo
		end
		say "The current Left Browse Related links:\nInput - Result"
		for i in (0..(el.length-1))
			say "#{i} - #{el[i].inner_html}"
		end
		c = ask "Would you like to make a change? y/n"
		while c == "y"
			d = ask "Which Left Browse Related link would you like to change?"
			d = d.to_i
			say "The current link text:
			#{el[d].inner_html}"
			input = ask "What would you like to change this link to?"
			el[d].inner_html = input
			text = doc.inner_html
			gold = File.open("#{new_file_name}", "wb")
			gold.write(text)		
			p = ask "Would you like to view your changes? y/n"
			if p == "y"
				`open #{new_file_name}`
			end
			c = ask "Would you like to change another Left Browse Related link? y/n"
			tips << a5
		end	
	end

	if e == "6"
		say "You are editing <%= color('6 - First Item in Results', RED, BOLD) %>"
		doc = Hpricot(text)
		el = doc/".ttl a"
		if el.empty?
			el = doc/".vip"
		end
		say "The current First Item in Results:"
		say "#{el[0].inner_html}"
		c = ask "Would you like to make a change? y/n"
		if c == "y"
			input = ask "What would you like to change this link to?"
			el[d].inner_html = input
			text = doc.inner_html
			gold = File.open("#{new_file_name}", "wb")
			gold.write(text)		
			p = ask "Would you like to view your changes? y/n"
			if p == "y"
				`open #{new_file_name}`
			end
			tips << a6
		end
	end

	if e == "7"
		say "You are editing <%= color('7 - Also Shop In', RED, BOLD) %>"
		doc = Hpricot(text)
		el = doc/"#OtherParents a"
		if el.empty?
			say "<%= color('There are no Also Shop In links on this page.', RED, BOLD) %>"
			redo
		end
		say "The current Also Shop In links:\nInput - Result"
		for i in (0..(el.length-1))
			say "#{i} - #{el[i].inner_html}"
		end
		c = ask "Would you like to make a change? y/n"
		while c == "y"
			d = ask "Which Also Shop In link would you like to change?"
			d = d.to_i
			say "The current link text:
			#{el[d].inner_html}"
			input = ask "What would you like to change this link to?"
			el[d].inner_html = input
			text = doc.inner_html
			gold = File.open("#{new_file_name}", "wb")
			gold.write(text)		
			p = ask "Would you like to view your changes? y/n"
			if p == "y"
				`open #{new_file_name}`
			end
			c = ask "Would you like to change another Also Shop In link? y/n"
			tips << a7
		end	
	end

	if e == "8"
		say "You are editing <%= color('8 - Rest of Results', RED, BOLD) %>"
		doc = Hpricot(text)
		el = doc/".ttl a"
		start = 0
		if el.empty?
			start = 1
		end
		el = doc/".vip"
		say "The current Result links:\nInput - Result"
		for i in (start..(el.length-1))
			say "#{i} - #{el[i].inner_html}"
		end
		c = ask "Would you like to make a change? y/n"
		while c == "y"
			d = ask "Which Result link would you like to change?"
			d = d.to_i
			say "The current link text:
			#{el[d].inner_html}"
			input = ask "What would you like to change this link to?"
			el[d].inner_html = input
			text = doc.inner_html
			gold = File.open("#{new_file_name}", "wb")
			gold.write(text)		
			p = ask "Would you like to view your changes? y/n"
			if p == "y"
				`open #{new_file_name}`
			end
			c = ask "Would you like to change another Result link? y/n"
			tips << a8
		end	
	end

	if e == "9"
	say "You are editing <%= color('9 - Collections You Might Like', RED, BOLD) %>"
	doc = Hpricot(text)
		el = doc/".fluid-cv-txt"
		if el.empty?
			say "<%= color('There are no Collections You Might Like on this page.', RED, BOLD) %>"
			redo
		end
		say "The current Collections You Might Like links:\nInput - Result"
		for i in (0..(el.length-1))
			say "#{i} - #{el[i].inner_html}"
		end
		c = ask "Would you like to make a change? y/n"
		while c == "y"
			d = ask "Which Collections You Might Like link would you like to change?"
			d = d.to_i
			say "The current link text:
			#{el[d].inner_html}"
			input = ask "What would you like to change this link to?"
			el[d].inner_html = input
			text = doc.inner_html
			gold = File.open("#{new_file_name}", "wb")
			gold.write(text)		
			p = ask "Would you like to view your changes? y/n"
			if p == "y"
				`open #{new_file_name}`
			end
			c = ask "Would you like to change another Collections You Might Like link? y/n"
			tips << a9
		end
	end

	if e == "10"
	say "You are editing <%= color('10 - Recommended Buying Guides', RED, BOLD) %>"
	doc = Hpricot(text)
		el = doc/".fluid-gv-header span"
		if el.empty?
			say "<%= color('There are no Recommended Buying Guides on this page.', RED, BOLD) %>"
			redo
		end
		say "The current Recommended Buying Guide links:\nInput - Result"
		for i in (0..(el.length-1))
			say "#{i} - #{el[i].inner_html}"
		end
		c = ask "Would you like to make a change? y/n"
		while c == "y"
			d = ask "Which Recommended Buying Guide link would you like to change?"
			d = d.to_i
			say "The current link text:
			#{el[d].inner_html}"
			input = ask "What would you like to change this link to?"
			el[d].inner_html = input
			text = doc.inner_html
			gold = File.open("#{new_file_name}", "wb")
			gold.write(text)		
			p = ask "Would you like to view your changes? y/n"
			if p == "y"
				`open #{new_file_name}`
			end
			c = ask "Would you like to change another Recommended Buying Guide link? y/n"
			tips << a10
		end
	end

	if e == "11"
	say "You are editing <%= color('11 - Bottom Browse Related', RED, BOLD) %>"
	doc = Hpricot(text)
		el = doc/".bwWpr .bw-ttl a"
		if el.empty?
			say "<%= color('There is no Bottom Browse Related on this page.', RED, BOLD) %>"
			redo
		end
		say "The current Bottom Browse Related links:\nInput - Result"
		for i in (0..(el.length-1))
			say "#{i} - #{el[i].inner_html}"
		end
		c = ask "Would you like to make a change? y/n"
		while c == "y"
			d = ask "Which Bottom Browse Related link would you like to change?"
			d = d.to_i
			say "The current link text:
			#{el[d].inner_html}"
			input = ask "What would you like to change this link to?"
			el[d].inner_html = input
			text = doc.inner_html
			gold = File.open("#{new_file_name}", "wb")
			gold.write(text)		
			p = ask "Would you like to view your changes? y/n"
			if p == "y"
				`open #{new_file_name}`
			end
			c = ask "Would you like to change another Browse Related link? y/n"
			tips << a11
		end
	end

	if e == "RESET"
	file = File.open("#{file_name}", "wb")
	file.write(original)
	say "You have reverted the file back to its original condition"
	end

	a = ask "Would you like to edit another element in this file? y/n"
end

if text != original
	say "<%= color('The desired changes have been made and the Test Question CSV has been updated.', BOLD) %>"
	tip = "The following items have been modified: #{tips.uniq.join(', ')}"
	CSV.open(tracking, "ab", :headers => true) do |out|
		out << [new_id, file_url_name, "TRUE", tip]
	end
end

