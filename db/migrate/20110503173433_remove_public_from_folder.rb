class RemovePublicFromFolder < ActiveRecord::Migration
  def self.up
    remove_column :folders, :public
  end

  def self.down
    add_column :folders, :public, :boolean, :default => false
  end
end
