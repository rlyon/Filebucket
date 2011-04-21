class User < ActiveRecord::Base
	has_many :assets
	has_many :folders
	has_many :shared_folders, :dependent => :destroy
	has_many :being_shared_folders, :class_name => "SharedFolder", :foreign_key => "shared_user_id", :dependent => :destroy

	# Include default devise modules. Others available are:
	# :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
	devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

	# Setup accessible (or protected) attributes for your model
	attr_accessible :email, :password, :password_confirmation, :remember_me
	attr_accessible :name

	validates :email, :presence => true, :uniqueness => true

end
