class Relationship < ApplicationRecord
  PART_VALUE = %w[Vo1 Vo2 GtVo Gt1 Gt2 Ba Dr Key その他].freeze
  validates :user_id, presence: true
  validates :band_id, presence: true
  validates :part,    presence: true, inclusion: { in: PART_VALUE }
  belongs_to :user
  belongs_to :band
end
