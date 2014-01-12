class RelaxNullConstraints < ActiveRecord::Migration
  def change
    change_column_null :drills, :title, true
    change_column_null :drills, :description, true
    change_column_null :drills, :user_id, true

    change_column_null :passages, :user_id, true

    change_column_null :songs, :user_id, true

    change_column_null :flash_cards, :teachable_id, true
    change_column_null :flash_cards, :teachable_type, true
    change_column_null :flash_cards, :meaning, true
    change_column_null :flash_cards, :part_of_speech, true
    change_column_null :flash_cards, :simplified, true
    change_column_null :flash_cards, :traditional, true
    change_column_null :flash_cards, :pinyin, true
    change_column_null :flash_cards, :jyutping, true

    change_column_null :examples, :simplified, true
    change_column_null :examples, :traditional, true
    change_column_null :examples, :pinyin, true
    change_column_null :examples, :jyutping, true
    change_column_null :examples, :translation, true
  end
end
