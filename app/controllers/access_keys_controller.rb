class AccessKeysController < ApplicationController
  before_filter :authenticate_user!
  def index
    @keys = current_user.access_keys
  end
  
  def show
    @key = current_user.access_keys.find(params[:id])
  end

  def new
    @key = current_user.access_keys.new
  end

  def create
    @key = current_user.access_keys.new(params[:access_key])
    if @key.save
      redirect_to access_keys_path, :notice => "Created key"
    else
      render 'new'
    end
  end

  def edit
    @key = current_user.access_keys.find(params[:id])
    if @key.nil?
      redirect_to root_url, :error => "You cannot edit keys that do not belong to you."
    else
      render 'edit'
    end
  end

  def update
    @key = current_user.access_keys.find(params[:id])
    if @key.update_attributes(params[:key])
      redirect_to access_keys_path, :notice => "Successfully updated the '#{@key.name}' key."
    else
      render 'edit'
    end
  end

  def destroy
    @key = current_user.access_keys.find(params[:id])
    @key.destroy
    flash[:notice] = "Successfully removed the key"
    redirect_to access_keys_path
  end

end
