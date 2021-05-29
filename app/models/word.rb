class Word < ApplicationRecord
  has_and_belongs_to_many :sentences
  has_and_belongs_to_many :queries
  has_and_belongs_to_many :choosen_results
end
