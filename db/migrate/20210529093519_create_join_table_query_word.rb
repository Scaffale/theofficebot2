class CreateJoinTableQueryWord < ActiveRecord::Migration[6.1]
  def change
    create_join_table :queries, :words do |t|
      t.index %i[query_id word_id]
      # t.index [:word_id, :query_id]
    end
  end
end
