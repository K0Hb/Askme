class Question < ApplicationRecord
  belongs_to :user

  MAX_TEXT_LENGTH = 280

  validates :body, presence: true, length: { maximum: MAX_TEXT_LENGTH }
end
