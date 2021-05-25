class CreateChoosenResults < ActiveRecord::Migration[6.1]
  def change
    create_table :choosen_results do |t|
      t.string :uniq_id
      t.bigint :query_history_id
      t.integer :hits

      t.timestamps
    end
  end
end
