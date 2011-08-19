class AddZipToFolders < ActiveRecord::Migration
  def self.up
    add_column :folders, :zipped_file, :string
    add_column :folders, :zipped_at, :datetime
  end

  def self.down
    remove_column :folders, :zipped_at
    remove_column :folders, :zipped_file
  end
end
