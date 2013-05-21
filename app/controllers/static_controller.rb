class StaticController < ApplicationController

  def home
  	
  end

  

  def results
  	current_search_data = params[:search_string]
  	saved_search_term = $redis["saved_search_term"]

  	Rails.logger.debug("SEARCHED TERM: "+ current_search_data + " saved: " + saved_search_term.to_s)
  	if(current_search_data == saved_search_term)
  		search_status = $redis["search_status"]
  		if(search_status == "finished")
  			@google_results = JSON.parse($redis["google_results"])
  			@bing_results = JSON.parse($redis["bing_results"])
  		end
  	else
  		FormSubmitter.perform_async(current_search_data)
  	end
  end


end
