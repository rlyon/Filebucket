class CreateInvites < ActiveRecord::Migration
  def self.up
    create_table :invites do |t|
      t.integer :user_id
      t.integer :invited_user_id
      t.string :invited_user_email
      t.string :message

      t.timestamps
    end
    
    add_index :invites, :user_id
    add_index :invites, :invited_user_id
  end

  def self.down
    drop_table :invites
  end
end
