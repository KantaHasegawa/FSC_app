class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 50 }, uniqueness: true
  validates :sex, presence: true, numericality: { less_than_or_equal_to: 1 }
  validates :generation, presence: true

  # メソッド
  # 渡されたユーザーの性別を文字列で返す
  def what_gender
    if gender == 0
      '男'
    else
      '女'
    end
  end
end
