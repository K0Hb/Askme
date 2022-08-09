class Question < ApplicationRecord
  MAX_TEXT_LENGTH = 280

  validates :body, presence: true, length: { maximum: MAX_TEXT_LENGTH }
end
