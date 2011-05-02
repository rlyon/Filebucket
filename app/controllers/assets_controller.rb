class AssetsController < ApplicationController
	before_filter :authenticate_user!, :except => ['get']
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
    
    respond_to do |format|
  		if @asset.save
  		  if @asset.folder
          @asset.folder.updated_at = @asset.updated_at
          @asset.folder.save
        end
  			#flash[:notice] = "Successfully created asset."
  			format.json { render :json => {:name => truncate_helper(@asset.file_name, :length => 50), :result => 'success', :msg => 'OK'}, :content_type => 'text/html' }
  			format.xml  { render :xml => @asset, :status => :created, :location => @asset }
  			format.html { redirect_to(root_url, :notice => "Successfully uploaded file(s).")}
  		else
  			#render :action => 'new'
  			format.json { render :json => { :name => truncate_helper(@asset.file_name, :length => 50), :result => 'error', :msg => "Error: #{@asset.errors.full_messages.join(',')}"}, :content_type => 'text/html' }
  			format.xml  { render :xml => @asset, :status => :created, :location => @asset }
  			format.html { render :action => 'new' }
  		end
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
	  if current_user
	    # Get file if the current user owns it
		  asset = current_user.assets.find_by_id(params[:id])
		  # Or get the file if it is public
		  asset ||= Asset.public_find_by_id(params[:id])
		  # Or get the file if it is shared with the current user 
		  asset ||= Asset.find(params[:id]) if current_user.has_share_access?(Asset.find_by_id(params[:id]).folder)
		else
		  asset = Asset.public_find_by_id(params[:id])
		end
		
		if asset
		  #data = open(URI.parse(URI.encode(asset.uploaded_file.path)).to_s)
		  #send_data data, :filename => asset.uploaded_file_file_name
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
	
private
  def truncate_helper(text, options = {})
    options.reverse_merge!(:length => 30)
    text.truncate(options.delete(:length), options) if text
  end	
end
