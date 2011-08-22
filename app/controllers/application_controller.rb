class ApplicationController < ActionController::Base
	protect_from_forgery
	
	private
	def key_signed_in?
	  session[:access_key_id] ? true : false 
  end
  
  def current_key
    @current_key ||= AccessKey.find(session['access_key_id']) if session['access_key_id']
  end
  
  helper_method :key_signed_in?
  helper_method :current_key
end
