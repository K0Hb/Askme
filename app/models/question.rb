class Question < ApplicationRecord
  MAX_TEXT_LENGTH = 280

  belongs_to :user
  belongs_to :author, class_name: 'User', optional: true
  has_and_belongs_to_many :hashtags

  # before_save :find_hashtags

  validates :body, presence: true, length: { maximum: MAX_TEXT_LENGTH }

  # def find_hashtags
  #   hashtags = (body + (answer.nil? ? '' : answer)).scan(/#\p{L}+/).map(&:downcase).uniq
  #   all_hashtags = Hashtag.all.map(&:name)
  #   hashtags.each do |tag|
  #     unless all_hashtags.include?(tag)
  #       hashtag = Hashtag.create(name: tag).save
  #     end
  #   end
  # end
end
