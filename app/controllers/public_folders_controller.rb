class PublicFoldersController < ApplicationController
  before_filter :authenticate_user!, :except => ['index', 'show']
  
  def index
    @public_folders = PublicFolder.find(:all)
    @public_view = true 
  end
  
  def show
    @current_folder = Folder.find(params[:id])
    @is_this_folder_public = true if @current_folder and @current_folder.root_public?

    if @current_folder.root_public?
      @folders = @current_folder.children
      @assets = @current_folder.assets.order("uploaded_file_file_name desc")
      @public_view = true 
    else
      flash[:error] = "This folder is not public."
      redirect_to root_url
    end
  end
  
  def destroy
    # stub
  end
  
  def update
    folder = current_user.folders.find(params[:id])

    if folder.private?
      public_folder = PublicFolder.new(:user_id => current_user.id, :folder_id => folder.id)
      if public_folder.save
        flash[:notice] = "#{folder.name} is now publically shared."
      else
        flash[:error] = "#{folder.name} could not be publically shared."
      end
    else
      if PublicFolder.delete_all(["folder_id = ?",folder.id])
        flash[:notice] = "#{folder.name} is now private."
      else
        flash[:error] = "#{folder.name} could not be made private."
      end
    end
    
    if folder.parent
      redirect_to folders_path(folder.parent)
    else
      redirect_to root_url
    end
  end
  
  def new
    # stub
  end
  
  def create
    # stub
  end
  
  def edit
    # stub
  end
end
