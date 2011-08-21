require 'zip/zipfilesystem'

# A container to hold assets (files) belonging to members
class Folder < ActiveRecord::Base
	acts_as_tree
	belongs_to :user
	has_many :keyed_folders, :dependent => :destroy
	has_many :keys, :through => :keyed_folders
	has_many :assets, :dependent => :destroy
	has_many :shared_folders, :dependent => :destroy
	has_many :public_folders, :dependent => :destroy
	
	attr_accessible :name, :parent_id, :user_id
	
	# Return the date when the folder was last updated
	def last_updated
		updated_at
	end
	
	# Return the number of files in the folder (non-recursive)
	def number_of_files
		assets.length
	end
  
  # Checks to see if the folder is a 'root' or home folder
  def is_root?
  	root == id
  end
  
  # Checks if the folder is shared
  def shared?
  	!self.shared_folders.empty?
  end
  
  # Checks if the folder is public
  def public?
    !self.public_folders.empty?
  end
  
  # Checks to see if the folder is private.  (not public)
  def private?
    self.public_folders.empty?
  end
  
  # Is the root folder public?
  def root_public?
    self.root.public?
  end
  
  # Is the root folder private?
  def root_private?
    self.root.private?
  end
  
  # Gather a list of all the email adresses that the folder is shared with
  def to_shared_emails
    #shared_to = SharedFolder.select("shared_email").find(:all, :conditions => ["folder_id = ?",id])
    email_addresses = Array.new
    shared_folders.each do |folder|
      email_addresses.push(folder.shared_email)
    end
    email_addresses
  end

  # Calculates the total size of all assets in the current folder and subfolders (recursive)
  def total_size
    self._total_size(self, 0)
  end
  
  # Creates a zip file and saves the location and creation time if the zip file location hasn't been
  # saved or the contents of the folder has changed. (needs to be recursive)
  def zip
    if !FileTest::directory?("/mnt/filebox/assets/zipfile_repository")
      Dir::mkdir("/mnt/filebox/assets/zipfile_repository")
    end
    if self.zipped_file.nil? or !File.file?(self.zipped_file)
      logger.info("[ZIP] Creating zipfile for #{self.name}")
      self.zipped_file = "/mnt/filebox/assets/zipfile_repository/#{SecureRandom.hex(32)}.zip"
      self.zipped_at = Time.now
      self.save!
      self._zip
    else
      # Check for modifications and rebuild if newer
      unless self.updated_at >= self.zipped_at
        logger.info("[ZIP] Rebuilding zipfile for #{self.name}")
        self._zip
      end
    end
    
    return self.zipped_file
  end
  
protected
  # Helper for the total size method which recursively calculates the size
  def _total_size(folder, size)
    folder.assets.each do |a|
      size = size + a.file_size
    end
    folder.children.each do |f|
      size = _total_size(f,size)
    end
    return size
  end
  
  # Helper for the zip method which creates the zip stream and calls the zip decender
  def _zip
    Zip::ZipFile.open(self.zipped_file, Zip::ZipFile::CREATE) do |z|
      self._zip_decender(z,self,nil)
    end
  end
  
  # Adds folder assets to the zip object and decends into the subfolders recursively adding
  # their assets as well.
  def _zip_decender(zipstream, folder, path)
    if path.nil?
      path = folder.name
    else
      path = path + "/" + folder.name
    end
    zipstream.dir.mkdir(path)
    
    folder.assets.each do |a|
      logger.info("[ZIP] Adding #{a.file_name} in #{a.uploaded_file.path}")
      zipstream.add("#{path}/#{a.file_name}", a.uploaded_file.path)
    end
    folder.children.each do |f|
      _zip_decender(zipstream, f, path)
    end
  end
end
