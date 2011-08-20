class RemoveFolderIdFromKeys < ActiveRecord::Migration
  def self.up
    remove_column :keys, :folder_id
  end

  def self.down
    add_column :keys, :folder_id, :integer
  end
end
