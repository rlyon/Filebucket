class KeyedFoldersController < ApplicationController
  before_filter :authenticate_user!
  def show
  end

  def new
  end

  def create
  end

  def edit
    @folder = current_user.folders.find(params[:id])
    @assigned_keys = @folder.keys
    @not_assigned_keys = current_user.keys - @assigned_keys
  end

  def update
    folder = current_user.folders.find(params[:folder_id])
    assign = params[:assign_keys]
    remove = params[:remove_keys]
    
    unless assign.nil?
      assign.each do |id|
        k = KeyedFolder.new(:folder_id => folder.id, :key_id => id)
        k.save!
      end
    end
    
    unless remove.nil?
      remove.each do |id|
        k = KeyedFolder.find(:first, :conditions => ['folder_id == ? AND key_id == ?', folder.id, id.to_i])
        k.destroy
      end
    end
    
    if folder.parent
      redirect_to folder_path(folder.parent), :notice => "Successfully updated keys"
    else
      redirect_to root_url
    end
  end

  def destroy
  end

end
