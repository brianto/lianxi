class CreatePins < ActiveRecord::Migration
  def change
    create_table :pins do |t|
      t.references :teachable, :polymorphic => true
      t.references :user
      t.boolean :pinned

      t.timestamps
    end
  end
end
