class RenameExpireToExpiresAtInKeys < ActiveRecord::Migration
  def self.up
    rename_column :keys, :expire, :expires_at
  end

  def self.down
    rename_column :keys, :expires_at, :expire
  end
end
