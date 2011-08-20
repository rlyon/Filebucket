class KeyedFolder < ActiveRecord::Base
  belongs_to :key
  belongs_to :folder
end
