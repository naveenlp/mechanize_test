class StaticController < ApplicationController

  def home
  	
  end

  

  def results
  	current_search_data = params[:search_data]
  	saved_search_term = $redis["saved_search_term"]
  	if(current_search_data == saved_search_term)
  		search_status = $redis["search_status"]
  		if(search_status == "finished")
  			@results = $redis["results"]
  	else
  		FormSubmitter.perform_async(saved_search_term)
  	end
  end


end
