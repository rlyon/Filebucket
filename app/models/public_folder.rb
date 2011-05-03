class PublicFolder < ActiveRecord::Base
  belongs_to :user
  belongs_to :folder
  attr_accessible :user_id, :folder_id
end
