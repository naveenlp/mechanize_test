require 'rubygems'
require 'mechanize'
require 'ostruct'

agent = Mechanize.new
google_form = agent.get("http://www.google.com/").form('f')
google_form.q = "maldives"
search_results = agent.submit(google_form, google_form.buttons.first)

@google_results = Array.new()
search_results.search("li.g").each do |search_list|
	link = search_list.search("a").first
	if(link.attribute('href').to_s.include?("/url?q="))
		link_obj = OpenStruct.new({ "text" => link.text, "url" => link.attribute('href').to_s.gsub('/url?q=','') });
		@google_results << link_obj

		puts link_obj.text 
		puts link_obj.url
		# puts link.text
		# puts link.attribute('href').to_s
		# puts "\n"
	end

	# puts (link.to_s + "\n\n") if !((link.attribute('href').to_s.include?("/url?")) || (link.attribute('href').to_s.include?("/search?")))
	 # if link.text != ("Cached" || "Similar")
	# puts search_list.dom_id.to_s
end

search_results = agent.get('http://www.bing.com/').forms[0].tap{|f| f.q = 'test'}.submit


@bing_results = Array.new()

search_results.search("li.sa_wr").each do |search_list|
	link = search_list.search("a").first
	link_obj = OpenStruct.new({ "text" => link.text, "url" => link.attribute('href').to_s});
	@bing_results << link_obj

	puts link_obj.text 
	puts link_obj.url
		# puts link.text
		# puts link.attribute('href').to_s
		# puts "\n"
	
	# puts (link.to_s + "\n\n") if !((link.attribute('href').to_s.include?("/url?")) || (link.attribute('href').to_s.include?("/search?")))
	 # if link.text != ("Cached" || "Similar")
	# puts search_list.dom_id.to_s
end

# (search_results/"li.g").each do |result|
# 	@sitesurl << (result/"a").first.attribute('href') if result.attribute('class').to_s == 'g'
# end

# puts @sitesurl.to_s
