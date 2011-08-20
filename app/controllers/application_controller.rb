class ApplicationController < ActionController::Base
	protect_from_forgery
	
	private
	def key_signed_in?
	  session[:key_id] ? true : false 
  end
  
  def current_key
    @current_key ||= Key.find(session['key_id']) if session['key_id']
  end
  
  helper_method :key_signed_in?
  helper_method :current_key
end
