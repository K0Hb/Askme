class User < ApplicationRecord
  include Gravtastic

  MAX_NICKNAME_LENGTH = 40
  VAILD_NICKNAME = /\A\w+\z/
  VALID_EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  has_secure_password
  has_many :questions, dependent: :delete_all

  before_validation :downcase_nickname_email

  validates :name, presence: true
  validates :nickname, presence: true, uniqueness: true, length: { maximum: MAX_NICKNAME_LENGTH }, format: { with: VAILD_NICKNAME }
  validates :email, presence: true, uniqueness: true, format: { with: VALID_EMAIL }

  gravtastic(secure: true, filetype: :png, size: 100, default: 'identicon')

  private

  def downcase_nickname_email
    nickname&.downcase!
    email&.downcase!
  end
end
