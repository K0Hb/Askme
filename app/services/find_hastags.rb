class FindHastags
  REGEX_HASHTAG = /#[\p{L}\d\S]+/

  def initialize(question)
    @question = question
  end

  def self.call(*args)
    new(*args).find_and_create_hashtag
  end

  def find_and_create_hashtag
    @question.hashtags =
      "#{@question.body} #{@question.answer}".downcase.scan(REGEX_HASHTAG).uniq.map do |tag|
        Hashtag.find_or_create_by(name: tag)
      end
  end
end