require 'rubygems'
require 'mechanize'

class FormSubmitter
	include Sidekiq::Worker
	sidekiq_options retry: false

	def perform(search_data)
		$redis["saved_search_term"] = search_data.to_s
  		$redis["search_status"] = "started"
  		
		agent = Mechanize.new
		page = agent.get("http://www.google.com/")
		google_form = page.form('f')
		google_form.q = search_data.to_s
		search_results = agent.submit(google_form, google_form.buttons.first)

		(search_results/"li.g").each do |result|
			@sitesurl << (result/"a").first.attribute('href') if result.attribute('class').to_s == 'g'
		end

		$redis["results"] =  @sitesurl

		# Rails.logger.debug( "results 4: "+@results)
		$redis["search_status"] = "finished"
	end

end