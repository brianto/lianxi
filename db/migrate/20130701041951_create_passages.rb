class CreatePassages < ActiveRecord::Migration
  def change
    create_table :passages do |t|

      t.timestamps
    end
  end
end
