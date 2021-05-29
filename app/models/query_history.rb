class QueryHistory < ApplicationRecord
  has_and_belongs_to_many :words
  has_many :choosen_results
end
