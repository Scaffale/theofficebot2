class ChoosenResult < ApplicationRecord
  has_and_belongs_to_many :words
  belongs_to :query_history
end
