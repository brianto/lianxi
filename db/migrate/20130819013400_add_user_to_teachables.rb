class AddUserToTeachables < ActiveRecord::Migration
  def change
    add_reference :drills, :users, :index => true
    add_reference :passages, :users, :index => true
    add_reference :songs, :users, :index => true
  end
end
