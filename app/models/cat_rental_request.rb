class CatRentalRequest < ApplicationRecord
  validates :cat_id, :start_date, :end_date, presence: true
  validates :status, inclusion: { in: %w(PENDING APPROVED DENIED), message: 'Invalid status' }
  validate :does_not_overlap_approved_request

  belongs_to :cat,
    primary_key: :id,
    foreign_key: :cat_id,
    class_name: 'Cat'

  def overlapping_requests
    CatRentalRequest.where("cat_id = ? AND id != ?", self.cat_id, self.id)
    .where("(start_date < ? AND end_date > ?) OR (start_date < ? AND end_date > ?)", start_date, start_date, end_date, end_date)
  end

  def overlapping_approved_requests
    overlapping_requests.where(status: 'APPROVED')
  end

  def does_not_overlap_approved_request
    if overlapping_approved_requests.exists?
      errors.add(:status, "Already approved request")
    end
  end

  def self.ordered_dates(id)
    CatRentalRequest
      .where(cat_id: id)
      .order('start_date')
  end

  def overlapping_pending_requests
    overlapping_requests.where(status: 'PENDING')
  end

  def approve!
    CatRentalRequest.transaction do
      self.update_attributes(status: "APPROVED")
      overlapping_pending_requests.update_all(status: "DENIED")
    end
  end

  def deny!
    self.update_attributes(status: "DENIED")
  end
end
