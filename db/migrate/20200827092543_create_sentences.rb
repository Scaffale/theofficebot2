# Creates the sentence, which is the core of the bot
class CreateSentences < ActiveRecord::Migration[6.0]
  def change
    create_table :sentences do |t|
      t.integer :season
      t.integer :episode
      t.string :file_name
      t.string :end_time
      t.string :start_time
      t.string :text
    end
  end
end
