class KeySessionsController < ApplicationController
  before_filter :log_out_user_if_logged_in
  
  def index
    unless current_key.nil?
      @folders = current_key.folders
      render 'index'
    else
      redirect_to keyauth_login_path, :error => "You need to log in with your email address and key to continue."
    end
  end

  def new
    unless key_signed_in?
      render 'new'
    else
      redirect_to keyauth_folders_path
    end
  end

  def create
    @key = AccessKey.find(:first, :conditions => ["email == ? AND auth == ?", params[:email], params[:auth]])
    unless @key.nil?
      session['access_key_id'] = @key.id
      redirect_to keyauth_folders_path, :notice => "You are logged in.  This key is valid until #{@key.expires_at}."
    else
      flash[:error] = "Invalid email or key."
      render "new"
    end
  end
  
  def destroy
    session['key_id'] = nil
    redirect_to root_url, :notice => "Your key has been logged out."
  end
  
private
  # Quietly log out a logged in user so our sessions do not interfere with each other 
  def log_out_user_if_logged_in
    if user_signed_in?
      sign_out
    end
  end
end
