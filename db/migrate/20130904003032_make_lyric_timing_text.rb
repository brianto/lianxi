class MakeLyricTimingText < ActiveRecord::Migration
  def change
    change_column :lyrics, :timing, :text
  end
end
