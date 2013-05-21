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

		# puts link_obj.text 
		# puts link_obj.url
		
	end

end



search_results = agent.get('http://www.bing.com/').forms[0].tap{|f| f.q = 'test'}.submit
@bing_results = Array.new()

search_results.search("li.sa_wr").each do |search_list|
	link = search_list.search("a").first
	link_obj = OpenStruct.new({ "text" => link.text, "url" => link.attribute('href').to_s});
	@bing_results << link_obj

	# puts link_obj.text 
	# puts link_obj.url
end
