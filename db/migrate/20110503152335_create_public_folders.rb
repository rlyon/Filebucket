class CreatePublicFolders < ActiveRecord::Migration
  def self.up
    create_table :public_folders do |t|
      t.integer :user_id
      t.integer :folder_id

      t.timestamps
    end
    
    add_index :public_folders, :user_id
    add_index :public_folders, :folder_id
  end

  def self.down
    drop_table :public_folders
  end
end
