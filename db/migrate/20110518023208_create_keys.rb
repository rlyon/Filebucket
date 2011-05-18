class CreateKeys < ActiveRecord::Migration
  def self.up
    create_table :keys do |t|
      t.integer :user_id
      t.string :name
      t.string :auth
      t.integer :folder_id
      t.datetime :expire

      t.timestamps
    end
  end

  def self.down
    drop_table :keys
  end
end
