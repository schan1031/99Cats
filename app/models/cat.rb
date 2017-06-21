class Cat < ApplicationRecord
  VALID_COLORS = %w(Black White Brown Grey Orange Silver Blue Red Green).freeze
  validates :birth_date, :name, presence: true
  validates :sex, inclusion: { in: %w(M F), message: 'Invalid Sex' }
  validates :color, inclusion: { in: VALID_COLORS, message: 'Invalid Color' }

  has_many :cat_rental_requests,
    primary_key: :id,
    foreign_key: :cat_id,
    class_name: 'CatRentalRequest'

  def age
    Time.now.year - self.birth_date.year
  end

  def self.colors
    VALID_COLORS
  end
end
