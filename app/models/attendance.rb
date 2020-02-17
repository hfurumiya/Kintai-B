class Attendance < ApplicationRecord
  belongs_to :user
  
  validates :worked_on, presence: true
  validates :note, length: { maximum: 50 }
  
  validate :finished_at_is_invalid_without_a_started_at

  def finished_at_is_invalid_without_a_started_at
    if started_at.blank? && finished_at.present?
      errors[:base ] << "出勤時間が要ります"
      # 勤怠１０章 errors.add(:started_at, "が必要です") if started_at.blank? && finished_at.present?
    end
  end
end
