class Folder < ActiveRecord::Base
	acts_as_tree
	belongs_to :user
	#has_many :keys, :dependent => :destroy
	has_many :assets, :dependent => :destroy
	has_many :shared_folders, :dependent => :destroy
	has_many :public_folders, :dependent => :destroy
	
	attr_accessible :name, :parent_id, :user_id
	
	def last_updated
		updated_at
	end
	
	def number_of_files
		assets.length
	end
  
  def is_root?
  	root == id
  end
  
  def shared?
  	!self.shared_folders.empty?
  end
  
  def public?
    !self.public_folders.empty?
  end
  
  def private?
    self.public_folders.empty?
  end
  
  def root_public?
    self.root.public?
  end
  
  def root_private?
    self.root.private?
  end
  
  def to_shared_emails
    #shared_to = SharedFolder.select("shared_email").find(:all, :conditions => ["folder_id = ?",id])
    email_addresses = Array.new
    shared_folders.each do |folder|
      email_addresses.push(folder.shared_email)
    end
    email_addresses
  end
  
  def zip
    if self.zipped_file.nil?
      self.zipped_file = "/tmp/uploader/#{SecureRandom.hex(32)}.zip"
      self.zipped_at = Time.now
      self.save!
      self._zip
    else
      # Check for modifications and rebuild if newer
      unless self.updated_at >= self.zipped_at
        logger.info("Rebuilding zipfile for #{self.name}")
        self._zip
      end
    end
    
    self.zipped_file
    
  end

protected
  def _zip
    Zip::ZipOutputStream.open(self.zipped_file) do |z|
      self.assets.each do |asset|
        z.put_next_entry(asset.name)
        z.print IO.read(asset.file.url)
      end
    end
  end

end
