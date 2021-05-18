class CreateQueryHistories < ActiveRecord::Migration[6.1]
  def change
    create_table :query_histories do |t|
      t.string :text
      t.integer :hits
      t.float :time_after
      t.float :time_before

      t.timestamps
    end
  end
end
