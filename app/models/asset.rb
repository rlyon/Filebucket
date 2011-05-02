class Asset < ActiveRecord::Base
	attr_accessible :user_id, :uploaded_file, :folder_id, :download_time, :username

	belongs_to :user
	belongs_to :folder

	has_attached_file :uploaded_file,
		:url => "/download/:id",
		:path => "#{Rails.root.to_s}/assets/:username/:folder_id/:basename.:extension"

	validates_attachment_size :uploaded_file, :less_than => 10.megabytes
	validates_attachment_presence :uploaded_file
	
	def file_name
		uploaded_file_file_name
	end

	def file_size
		uploaded_file_file_size
	end
	
	def username
	  user.username
	end
	
	def get_folder_id
	  fid = (folder_id.to_s || "home")
	  return fid
	end
	
	def self.public_find_by_id(id)
	  file = find(id)
	  if file.folder.is_public?
	    return file
	  end
	  nil
	end

end
