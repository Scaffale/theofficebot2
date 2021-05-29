class CreateJoinTableSentenceWord < ActiveRecord::Migration[6.1]
  def change
    create_join_table :sentences, :words do |t|
      t.index %i[sentence_id word_id]
      # t.index [:word_id, :sentence_id]
    end
  end
end
