# frozen_string_literal: true

class Band < ApplicationRecord
  mount_uploader :image, BandImageUploader
  validates :name, presence: true, length: { maximum: 30 }, uniqueness: true
  has_many :relationships, dependent: :destroy
  has_many :users, through: :relationships
  has_many :notifications, dependent: :destroy
  accepts_nested_attributes_for :relationships, allow_destroy: true
  before_validation :user_ids_be_uniq
  before_validation :parts_be_uniq

  # メソッド
  def user_ids_be_uniq
    resource_be_uniq(relationships, :user_id)
  end

  def parts_be_uniq
    resource_be_uniq(relationships, :part)
  end

  # DB保存前にparamsを参照し一意性を検証する
  def resource_be_uniq(collection, attribute_name)
    success = true
    uniq = []
    collection.each do |m|
      # 削除されるレコードの一意性は検証しなくてよい (例 削除=>伊藤,Gt1 追加=>佐藤,Gt1 だった場合レコードにGt1が共存するわけではないので通してよい)
      unless m['destroy_check'] == true
        if uniq.include?(m[attribute_name])
          errors.add(:base, 'メンバーまたはパートが重複しています')
          success = false
        elsif m[attribute_name] != 0 # user_id = 0(募集中)は複数存在して良い
          uniq << m[attribute_name]
        end
      end
    end
    success
  end
end
