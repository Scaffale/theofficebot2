# Tengo a memoria i risultati scelti per mostrarli
class ChoosenResult < ApplicationRecord
  def new_name(*_args)
    uniq_id
  end
end
