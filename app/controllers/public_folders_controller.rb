class PublicFoldersController < ApplicationController
  before_filter :authenticate_user!, :except => ['index', 'show']
  
  def index
    @public_folders = PublicFolder.find(:all)
  end
  
  def show
    current_folder = Folder.find_by_id(params[:id])
    if current_folder.root_public?
      @folders = current_folder.children
      @assets = current_folder.assets.order("uploaded_file_file_name desc")
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
      redirect_to browse_path(folder.parent)
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
