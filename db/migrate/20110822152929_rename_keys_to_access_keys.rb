class RenameKeysToAccessKeys < ActiveRecord::Migration
  def self.up
    rename_table :keys, :access_keys
  end

  def self.down
    rename_table :access_keys, :keys
  end
end
