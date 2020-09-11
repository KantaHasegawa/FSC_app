# frozen_string_literal: true

class Relationship < ApplicationRecord
  PART_VALUE = %w[Vo1 Vo2 GtVo Gt1 Gt2 Ba Dr Key その他].freeze
  belongs_to :user, optional: true
  belongs_to :band
  has_many :notifications, dependent: :destroy

  def offering?
    user_id == 0
  end
end
