class StaticController < ApplicationController

  def home
  	
  end

  

  def results
  	FormSubmitter.perform_async(params[:search_data])
  	
  end


end
