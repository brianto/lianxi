class AddUserToTeachables < ActiveRecord::Migration
  def change
    add_column :drills, :user_id, :integer, :null => false
    add_column :passages, :user_id, :integer, :null => false
    add_column :songs, :user_id, :integer, :null => false
  end
end
