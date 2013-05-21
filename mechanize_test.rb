require 'rubygems'
require 'mechanize'

agent = Mechanize.new
page = agent.get("http://www.google.com/")
google_form = page.form('f')
google_form.q = "maldives"
search_results = agent.submit(google_form, google_form.buttons.first)

search_results.search("li.g").each do |search_list|
	link = search_list.search("a").first
	puts link.text
	puts link.attribute('href').to_s
	puts "\n"
	# puts (link.to_s + "\n\n") if !((link.attribute('href').to_s.include?("/url?")) || (link.attribute('href').to_s.include?("/search?")))
	 # if link.text != ("Cached" || "Similar")
	# puts search_list.dom_id.to_s
end

# (search_results/"li.g").each do |result|
# 	@sitesurl << (result/"a").first.attribute('href') if result.attribute('class').to_s == 'g'
# end

# puts @sitesurl.to_s
