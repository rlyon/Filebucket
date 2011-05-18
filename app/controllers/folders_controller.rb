class FoldersController < ApplicationController
	before_filter :authenticate_user!, :except => [ 'index' ] 
	@public_view = false
	
	def index
	  if user_signed_in?
		  @being_shared_folders = current_user.shared_folders_by_others
			@folders = current_user.folders.roots
			@assets = current_user.assets.where("folder_id is NULL").order("uploaded_file_file_name desc")
		end
	end

	def show
    @current_folder = current_user.folders.find_by_id(params[:id])  
    @is_this_folder_being_shared = false if @current_folder
    
    if @current_folder.nil?
      folder = Folder.find_by_id(params[:id])      
      @current_folder ||= folder if current_user.has_share_access?(folder)
      @is_this_folder_being_shared = true if @current_folder
    end
    
    if @current_folder
      @being_shared_folders = []
      @folders = @current_folder.children
      @assets = @current_folder.assets.order("uploaded_file_file_name desc")
    else
      flash[:error] = "The folder does not belong to you."
      redirect_to root_url
    end
	end

	def new
		@folder = current_user.folders.new
		if params[:folder_id]
			@current_folder = current_user.folders.find(params[:folder_id])
		@folder.parent_id = @current_folder.id
		end
	end

	def create
		@folder = current_user.folders.new
		@folder.name = params[:name]
		if params[:parent_id]
		  @current_folder = current_user.folders.find_by_id(params[:parent_id])
	  end
		@folder.parent_id = @current_folder.id unless @current_folder.nil?

		# placeholder for inheriting shared settings.		
		if @folder.save
			flash[:notice] = "Successfully created folder."
			if @folder.parent
				redirect_to folder_path(@folder.parent)
			else
				redirect_to root_url
			end
		else
			render :action => 'new'
		end
	end

	def edit
		@folder = current_user.folders.find(params[:folder_id])
		@current_folder = @folder.parent
	end

	def update
		@folder = current_user.folders.find(params[:id])
		if @folder.update_attributes(params[:folder])
			flash[:notice] = "Successfully renamed folder."
			if @folder.parent
				redirect_to folders_path(@folder.parent)
			else
				redirect_to root_url
			end
		else
			render :action => 'edit'
		end
	end

	def destroy
		@folder = current_user.folders.find(params[:id])
		@parent_folder = @folder.parent
		@folder.destroy
		flash[:notice] = "Successfully deleted the folder and all the contents inside."
		if @parent_folder
			redirect_to folder_path(@parent_folder)
		else
			redirect_to root_url
		end
	end
	
  def share  
  	@email_addresses = params[:email_addresses].split(",")
  	
  	current_folder = Folder.find(params[:folder_id])
  	all_email_addresses = current_folder.to_shared_emails
  	removed_email_addresses = all_email_addresses - @email_addresses
  	new_email_addresses = @email_addresses - all_email_addresses
  	
  	logger.debug new_email_addresses
  	logger.debug removed_email_addresses
  	
  	new_email_addresses.each do |email_address|
  	  @shared_folder = current_user.shared_folders.new
  	  @shared_folder.folder_id = params[:folder_id]
  	  @shared_folder.shared_email = email_address.strip
  	  shared_user = User.find_by_email(email_address)
  	  @shared_folder.shared_user_id = shared_user.id if shared_user
  	  @shared_folder.message = params[:message]
  	  @shared_folder.save

  	  UserMailer.invitation_to_share(@shared_folder).deliver
  	  UserMailer.share_notice_to_admin(@shared_folder).deliver
  	end
  	
  	removed_email_addresses.each do |email_address|
  	  SharedFolder.delete_all(["folder_id = ? AND shared_email = ?",params[:folder_id],email_address])
  	end

  	respond_to do |format|
  	  format.js {
  	  }
  	end
  end
  
  def unshare
    @current_folder = current_user.folders.find(params[:folder_id])
    SharedFolder.delete_all(["folder_id = ?",@current_folder.id])
    respond_to do |format|
      format.js {
      }
    end
  end
  
  def notify
    email_addresses = params[:email_addresses].split(",")
    current_folder = Folder.find(params[:folder_id])
    all_email_addresses = current_folder.to_shared_emails
    valid_email_addresses = all_email_addresses&email_addresses
    
    # We don't want to allow any email address that are not part of the shared folder addresses.
    valid_email_addresses.each do |email_address|
      UserMailer.notify_shared_folder_user(current_folder,email_address.strip,params[:message]).deliver
    end
    
    UserMailer.notify_shared_folder_owner(current_folder,valid_email_addresses).deliver
    
    respond_to do |format|
      format.js {
      }
    end
  end
	
end
