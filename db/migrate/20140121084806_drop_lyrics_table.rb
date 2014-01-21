class DropLyricsTable < ActiveRecord::Migration
  def change
    drop_table :lyrics
  end
end
