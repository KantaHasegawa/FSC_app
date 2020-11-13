# frozen_string_literal: true

class Relationship < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :band
  has_many :notifications, dependent: :destroy
end
