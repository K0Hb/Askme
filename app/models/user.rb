class User < ApplicationRecord
  has_many :questions

  MAX_NICKNAME_LENGTH = 40
  VAILD_NICKNAME = /\A\w+\z/
  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  has_secure_password

  before_validation :downcase_nickname

  validates :name, presence: true
  validates :nickname, presence: true, uniqueness: true, length: { maximum: MAX_NICKNAME_LENGTH }, format: { with: VAILD_NICKNAME }
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL }

  def downcase_nickname
    nickname.downcase!
  end
end
