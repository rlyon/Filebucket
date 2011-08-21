# Assets (files) that belong to members.
class Asset < ActiveRecord::Base
	attr_accessible :user_id, :uploaded_file, :folder_id, :download_time, :username

	belongs_to :user
	belongs_to :folder

	has_attached_file :uploaded_file,
		:url => "/download/:id",
		:path => "/mnt/filebox/assets/:username/:folder_id/:basename.:extension"

	validates_attachment_size :uploaded_file, :less_than => 5.gigabytes
	validates_attachment_presence :uploaded_file
	
	# Return the filename of an uploaded asset
	def file_name
		uploaded_file_file_name
	end

  # Return the file size of an uploaded asset
	def file_size
		uploaded_file_file_size
	end
	
	# Return the username for the owner of the asset
	def username
	  user.username
	end
	
	# Return the folder id as a string or home.  Why is this here?
	def get_folder_id
	  fid = (folder_id.to_s || "home")
	  return fid
	end
	
	# Find a public asset by its id.  If the folder is public we currently assume that the file is public.
	# This may change as we add more sophisticated ACL handling. i.e. asset has an ACL which determines
	# all public, sharing, readability, writeability, and file locking. 
	def self.public_find_by_id(id)
	  file = find(id)
	  if file.folder.public?
	    return file
	  end
	  nil
	end

end
