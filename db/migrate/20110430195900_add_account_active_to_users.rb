class AddAccountActiveToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :account_active, :boolean, :default => false
  end

  def self.down
    remove_column :users, :account_active
  end
end
