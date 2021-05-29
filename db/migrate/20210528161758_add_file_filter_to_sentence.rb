class AddFileFilterToSentence < ActiveRecord::Migration[6.1]
  def change
    add_column :sentences, :file_filter, :string
  end
end
