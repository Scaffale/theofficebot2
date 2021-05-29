class CreateJoinTableChoosenResultWord < ActiveRecord::Migration[6.1]
  def change
    create_join_table :choosen_results, :words do |t|
      t.index %i[choosen_result_id word_id]
      # t.index [:word_id, :choosen_result_id]
    end
  end
end
