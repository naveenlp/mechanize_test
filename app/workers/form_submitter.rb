require 'rubygems'
require 'mechanize'

class FormSubmitter
	include Sidekiq::Worker
	sidekiq_options retry: false

	def perform(search_data)
		$redis["saved_search_term"] = search_data.to_s
  		$redis["search_status"] = "started"
  		
  		agent = Mechanize.new
  		google_form = agent.get("http://www.google.com/").form('f')
  		google_form.q = "maldives"
  		search_results = agent.submit(google_form, google_form.buttons.first)

  		@google_results = Array.new()
  		search_results.search("li.g").each do |search_list|
  			link = search_list.search("a").first
  			if(link.attribute('href').to_s.include?("/url?q="))
  				link_obj = { "text" => link.text, "url" => link.attribute('href').to_s.gsub('/url?q=','') };
  				@google_results << link_obj

				Rails.logger.debug link_obj["text"] 
				Rails.logger.debug link_obj["url"]
		
			end

		end

		search_results = agent.get('http://www.bing.com/').forms[0].tap{|f| f.q = 'test'}.submit
		@bing_results = Array.new()

		search_results.search("li.sa_wr").each do |search_list|
			link = search_list.search("a").first
			link_obj = { "text" => link.text, "url" => link.attribute('href').to_s};
			@bing_results << link_obj

			Rails.logger.debug link_obj["text"] 
			Rails.logger.debug link_obj["url"]
		end

		$redis.set("google_results", @google_results.to_json)
		$redis.set("bing_results",@bing_results.to_json)

		# Rails.logger.debug( "results 4: "+@results)
		$redis["search_status"] = "finished"
	end

end