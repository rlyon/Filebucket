class AddPublicToFolder < ActiveRecord::Migration
  def self.up
    add_column :folders, :public, :boolean, :default => false
  end

  def self.down
    remove_column :folders, :public
  end
end
