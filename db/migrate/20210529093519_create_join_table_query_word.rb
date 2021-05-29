class CreateJoinTableQueryWord < ActiveRecord::Migration[6.1]
  def change
    create_join_table :query_histories, :words do |t|
      t.index %i[query_history_id word_id]
      # t.index [:word_id, :query_id]
    end
  end
end
