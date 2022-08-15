class Question < ApplicationRecord
  belongs_to :user
  belongs_to :author, class_name: 'User', optional: true

  MAX_TEXT_LENGTH = 280

  validates :body, presence: true, length: { maximum: MAX_TEXT_LENGTH }
end
