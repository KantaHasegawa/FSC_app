# frozen_string_literal: true

class Band < ApplicationRecord
  mount_uploader :image, BandImageUploader
  validates :name, presence: true, length: { maximum: 30 }, uniqueness: true
  has_many :relationships, dependent: :destroy
  has_many :users, through: :relationships
  has_many :notifications, dependent: :destroy
  accepts_nested_attributes_for :relationships, allow_destroy: true



  def invitation_notification(invitation_users, current_user)
    invitation_users.each do |v|
      visited_user_id = v[1]['user_id'].to_i
      if visited_user_id == 0 || visited_user_id == current_user.id
        next
      else
        invitation_notification = current_user.active_notifications.new(
          band_id: id,
          visited_id: visited_user_id,
          relationship_id: Relationship.find_by(band_id: id, user_id: visited_user_id).id,
          action: 'invitation'
        )
        invitation_notification.save if invitation_notification.valid?
      end
    end
  end

  def participated_notification(relationship, current_user) # 参加通知
    user_ids = Relationship.where(band_id: id, permission: true).where.not(user_id: current_user.id).select(:user_id)
    members = User.where(id: user_ids) # 招待を承認済みかつ自分を覗いたバンドメンバーに通知を送る
    members.each do |member|
      participated_notification = current_user.active_notifications.new(
        band_id: id,
        visited_id: member.id,
        relationship_id: relationship.id,
        action: 'participated'
      )
      participated_notification.save if participated_notification.valid?
    end
  end
end
