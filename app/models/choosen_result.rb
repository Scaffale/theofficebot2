class ChoosenResult < ApplicationRecord
  belongs_to :query_history
  has_many :words, through: :query_history
end
