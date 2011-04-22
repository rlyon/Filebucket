class FoldersController < ApplicationController
	before_filter :authenticate_user!, :except => [:index, :browse]
	def index
		@folders = Folder.where(:public => true).order("updated_at desc").roots
	end

	def show
		
	end

	def new
		@folder = current_user.folders.new
		if params[:folder_id]
			@current_folder = current_user.folders.find(params[:folder_id])
		@folder.parent_id = @current_folder.id
		end
	end

	def create
		@folder = current_user.folders.new(params[:folder])
		if @folder.save
			flash[:notice] = "Successfully created folder."

			if @folder.parent
				redirect_to browse_path(@folder.parent)
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
				redirect_to browse_path(@folder.parent)
			else
				redirect_to root_url
			end
		else
			render :action => 'edit'
		end
	end

	def destroy
		@folder = current_user.folders.find(params[:id])
		@parent_folder = @folder.parent #grabbing the parent folder

		#this will destroy the folder along with all the contents inside
		#sub folders will also be deleted too as well as all files inside
		@folder.destroy
		flash[:notice] = "Successfully deleted the folder and all the contents inside."

		#redirect to a relevant path depending on the parent folder
		if @parent_folder
			redirect_to browse_path(@parent_folder)
		else
			redirect_to root_url
		end
	end
	
	def publicize
		selected_folder = current_user.folders.find(params[:folder_id])
		
		# If they are both public we are going to try to set a directory
		# under a public directory to private.  We don't want that.
		if selected_folder.parent and selected_folder.parent.is_public? and selected_folder.is_public?
			flash[:error] = "#{selected_folder.name} could not be changed.  You cannot keep private directories under public ones."
		else
			selected_folder.public = !selected_folder.is_public?
			is_shared = selected_folder.is_public? ? "public" : "private"
			# This is a recursive operation all child directories are changed
			publicize_children(selected_folder,selected_folder.public)
			
			if selected_folder.save
				flash[:notice] = "#{selected_folder.name} has been set to #{is_shared}."
			else
				flash[:error] = "#{selected_folder.name} could not be changed."
			end
		end
		
		if selected_folder.parent
			redirect_to browse_path(selected_folder.parent)
		else
			redirect_to root_url
		end
	end
	
	def browse

		@current_folder = Folder.find(params[:folder_id])

		if @current_folder.is_public?

			#getting the folders which are inside this @current_folder
			@folders = @current_folder.children

			#We need to fix this to show files under a specific folder if we are viewing that folder
			@assets = @current_folder.assets.order("uploaded_file_file_name desc")

			render :action => "index"
		else
			flash[:error] = "Don't be cheeky! Mind your own folders!"
			redirect_to root_url
		end
	end
	
private
	def publicize_children(root,value)
		root.children.each do |folder|
			if !folder.children.empty?
				publicize_children(folder,value)
			end
			folder.public = value
			folder.save
		end
	end
end
