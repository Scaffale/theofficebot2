class Word < ApplicationRecord
  has_and_belongs_to_many :sentences
  has_and_belongs_to_many :query_histories
  has_many :choosen_results, through: :queries
end
