class AddTitleAndDescriptionToDrills < ActiveRecord::Migration
  def change
    add_column :drills, :title, :string
    add_column :drills, :description, :text
  end
end
