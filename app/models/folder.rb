class Folder < ActiveRecord::Base
	acts_as_tree
	belongs_to :user
	has_many :assets, :dependent => :destroy
	has_many :shared_folders, :dependent => :destroy
	
	attr_accessible :name, :parent_id, :user_id
	
	def last_updated
		updated_at
	end
	
	def number_of_files
		assets.length
	end
	
  def is_public?
  	public
  end
  
  def is_root?
  	root == id
  end
  
  def shared?
  	!self.shared_assets.empty?
  end

end
