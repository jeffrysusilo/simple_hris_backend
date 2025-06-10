class Attendance < ApplicationRecord
  belongs_to :user

  validates :date, presence: true
  validates :user_id, uniqueness: { scope: :date, message: "sudah check-in hari ini" }
end
