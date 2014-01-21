class MoveLyricColumnsToSong < ActiveRecord::Migration
  def change
    rename_column :songs, :url, :youtubeId

    add_column :songs, :dialect, :string

    add_column :songs, :simplified, :text
    add_column :songs, :traditional, :text
    add_column :songs, :translation, :text
    add_column :songs, :timing, :text
  end
end
