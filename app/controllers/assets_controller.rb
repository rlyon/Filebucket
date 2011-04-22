class AssetsController < ApplicationController
	before_filter :authenticate_user!
	def index
		@assets = current_user.assets
	end

	def show
		@asset = current_user.assets.find(params[:id])
	end

	def new
		@asset = current_user.assets.build
		if params[:folder_id]
			@current_folder = current_user.folders.find(params[:folder_id])
			@asset.folder_id = @current_folder.id
		end
	end

	def create
		@asset = current_user.assets.build(params[:asset])
		if @asset.save
			flash[:notice] = "Successfully created asset."
			if @asset.folder
				@asset.folder.updated_at = @asset.updated_at
				@asset.folder.save
				redirect_to browse_path(@asset.folder)
			else
				redirect_to root_url
			end
		else
			render :action => 'new'
		end
	end

	def edit
		@asset = current_user.assets.find(params[:id])
	end

	def update
		@asset = current_user.assets.find(params[:id])
		if @asset.update_attributes(params[:asset])
			redirect_to @asset, :notice  => "Successfully updated asset."
		else
			render :action => 'edit'
		end
	end

	def destroy
		@asset = current_user.assets.find(params[:id])
		@parent_folder = @asset.folder #grabbing the parent folder before deleting the record
		@asset.destroy
		flash[:notice] = "Successfully deleted the file."

		#redirect to a relevant path depending on the parent folder
		if @parent_folder
			redirect_to browse_path(@parent_folder)
		else
			redirect_to root_url
		end
	end

	def get
		asset = current_user.assets.find(params[:id])
		if asset
			send_file asset.uploaded_file.path, :type => asset.uploaded_file_content_type
		else
			flash[:error] = "You can't access files that don't belong to you!"
			if @parent_folder
				redirect_to browse_path(@parent_folder)
			else
				redirect_to root_url
			end
		end
	end
end
