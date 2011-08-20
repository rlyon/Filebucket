class AddEmailToKeys < ActiveRecord::Migration
  def self.up
    add_column :keys, :email, :string
  end

  def self.down
    remove_column :keys, :email
  end
end
