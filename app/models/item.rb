class Item < ApplicationRecord
  # belongs_to :user
  enum :status, [:available, :reserved, :sold]
end
