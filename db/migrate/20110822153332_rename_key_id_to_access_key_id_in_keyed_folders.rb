class RenameKeyIdToAccessKeyIdInKeyedFolders < ActiveRecord::Migration
  def self.up
    rename_column :keyed_folders, :key_id, :access_key_id
  end

  def self.down
    rename_column :keyed_folders, :access_key_id, :key_id
  end
end
