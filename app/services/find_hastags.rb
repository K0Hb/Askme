class FindHastags
  REGEX_HASHTAG = /#[\p{L}\d\S]+/

  def initialize(question)
    @question = question
  end

  def self.call(*args)
    new(*args).find_and_create_hastag
  end

  def find_and_create_hastag
    hashtags = (@question.body + " " + (@question&.answer.nil? ? '' : @question.answer)).scan(REGEX_HASHTAG).map(&:downcase).uniq
    delete_independent_hashtags(hashtags)
    hashtags.each do |tag|
      hashtag = Hashtag.find_or_create_by(name: tag)
      unless @question.hashtags.include?(hashtag)
        @question.hashtags << hashtag
      end
    end
  end

  def delete_independent_hashtags(hashtags)
    independent_hashtags = @question.hashtags.pluck(:name) - hashtags
    independent_hashtags.each do |hashtag|
      @question.hashtags.find_by_name(hashtag).delete
    end
  end
end