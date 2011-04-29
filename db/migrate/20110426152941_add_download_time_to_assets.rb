class AddDownloadTimeToAssets < ActiveRecord::Migration
  def self.up
    add_column :assets, :download_time, :datetime
  end

  def self.down
    remove_column :assets, :download_time
  end
end
