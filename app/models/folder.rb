class Folder < ActiveRecord::Base
	acts_as_tree
	belongs_to :user
	has_many :assets, :dependent => :destroy
	attr_accessible :name, :parent_id, :user_id
	
	def last_updated
		updated_at
	end
	
	def number_of_files
		assets.length
	end
end
