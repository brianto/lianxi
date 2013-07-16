class CreateDrills < ActiveRecord::Migration
  def change
    create_table :drills do |t|

      t.timestamps
    end
  end
end
