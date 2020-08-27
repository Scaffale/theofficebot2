class CreateSentences < ActiveRecord::Migration[6.0]
  def change
    create_table :sentences do |t|
      t.integer :season
      t.integer :episode
      t.string :file_name
      t.integer :end_time
      t.integer :start_time
      t.string :text
    end
  end
end
