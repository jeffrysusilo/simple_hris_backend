class Employee < ApplicationRecord
  belongs_to :user

  # Validasi kalau perlu
  validates :position, presence: true
end
