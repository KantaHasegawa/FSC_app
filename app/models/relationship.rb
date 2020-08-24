class Relationship < ApplicationRecord
  PART_VALUE = %w[Vo1 Vo2 GtVo Gt1 Gt2 Ba Dr Key その他].freeze
  validates :user_id, presence: true, uniqueness: { scope: :band_id }, unless: :offering?
  # validates :band_id, presence: true
  validates :part,    presence: true, uniqueness: { scope: :band_id }, inclusion: { in: PART_VALUE }
  belongs_to :user, optional: true
  belongs_to :band

  def offering?
    user_id == 0
  end
end
