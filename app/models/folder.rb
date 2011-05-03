class Folder < ActiveRecord::Base
	acts_as_tree
	belongs_to :user
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

end
