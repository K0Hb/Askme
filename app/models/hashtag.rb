class Hashtag < ApplicationRecord
  has_many :question_hashtags
  has_many :questions, through: :question_hashtags, source: :question
  validates :name, presence: true, uniqueness: true
end
