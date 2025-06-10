class LeaveRequest < ApplicationRecord
  belongs_to :user

  STATUSES = ['pending', 'approved', 'rejected']

  validates :start_date, :end_date, :reason, presence: true
  validates :status, inclusion: { in: STATUSES }

  validate :end_date_after_start_date

  private

  def end_date_after_start_date
    if end_date < start_date
      errors.add(:end_date, "harus setelah tanggal mulai")
    end
  end
end

