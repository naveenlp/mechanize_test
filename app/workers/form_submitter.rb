require 'rubygems'
require 'mechanize'

class FormSubmitter
	include Sidekiq::Worker
	sidekiq_options retry: false

	def perform(search_data)
		Rails.logger.debug( "results 0: ")
		agent = Mechanize.new
		Rails.logger.debug( "results 1: ")
		page = agent.get("http://www.google.com/")
		Rails.logger.debug( "results 2: ")
		google_form = page.form('f')
		google_form.q = search_data.to_s
		page = agent.submit(google_form, google_form.buttons.first)

		Rails.logger.debug( "results 3: ")
		@results = page.to_s
		# Rails.logger.debug( "results 4: "+@results)
	end

end