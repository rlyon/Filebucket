class KeysController < ApplicationController
  def index
    @keys = current_user.keys
  end
  
  def show
    @key = current_user.keys.find_by_id(params[:id])
  end

  def new
    @key = current_user.keys.new
  end

  def create
    @key = current_user.keys.create(params[:key])
    if @key.save
      redirect_to keys_path, :notice => "Created key"
    else
      flash[:error] = "Could not save key"
      render 'new'
    end
  end

  def delete
  end

end
