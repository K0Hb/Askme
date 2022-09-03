class Question < ApplicationRecord
  MAX_TEXT_LENGTH = 280

  belongs_to :user
  belongs_to :author, class_name: 'User', optional: true, foreign_key: 'author_id'
  has_many :question_hashtags
  has_many :hashtags, through: :question_hashtags, source: :hashtag

  validates :body, presence: true, length: { maximum: MAX_TEXT_LENGTH }

  validate :user_id_not_changed

  private

  def user_id_not_changed
    if user_id_changed? && self.persisted?
      errors.add(:user_id, "Нельзя менять назначение вопроса")
    end
  end
end
