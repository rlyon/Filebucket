# Shared folder model.  Many to many relationship between users and folders.  Also maintains the 
# email address in case the 'shared with' user does not have an account yet.
class SharedFolder < ActiveRecord::Base
	attr_accessible :user_id, :shared_email, :shared_user_id,  :message,  :folder_id
  belongs_to :user
  belongs_to :shared_user, :class_name => "User", :foreign_key => "shared_user_id"
  belongs_to :folder
end
