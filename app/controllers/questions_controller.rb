class QuestionsController < ApplicationController
  REGEX_HASHTAG = /#[\p{L}\d\S]+/

  before_action :ensure_current_user, only: %i[update destroy edit]
  before_action :set_question_for_current_user, only: %i[update destroy edit]

  def create
    question_params = params.require(:question).permit(:body, :user_id)

    @question = Question.create(question_params)

    # @question.author_id = current_user.nil? ? nil : current_user.id
    @question.author = current_user

    if @question.save
      find_hashtags(@question)
      redirect_to user_path(@question.user.nickname), notice: 'Новый вопрос создан!'
    else
      render :new
    end
  end

  def update
    question_params = params.require(:question).permit(:body, :answer)

    @question.update(question_params)

    redirect_to user_path(@question.user), notice: 'Сохранили вопрос!'
  end

  def destroy
    @user = @question.user
    @question.destroy

    redirect_to user_path(@user), notice: 'Вопрос удалён!'
  end

  def show
    @question = Question.find(params[:id])
  end

  def index
    @hashtags = Hashtag.all
    @questions = Question.order(created_at: :asc).last(10)
    @users = User.order(created_at: :asc).last(10)
  end

  def new
    @user = User.find(params[:user_id])
    @question = Question.new
  end

  def edit
  end

  private

  def find_hashtags(question)
    hashtags = (question.body + (question.answer.nil? ? '' : answer)).scan(REGEX_HASHTAG).map(&:downcase).uniq
    all_hashtags = Hashtag.all.map(&:name)
    hashtags.each do |tag|
      hashtag = Hashtag.find_by_name(tag)
      hashtag ||= Hashtag.create(name: tag)
      question.hashtags << hashtag
      unless all_hashtags.include?(tag)
        hashtag.save
      end
    end
  end

  def ensure_current_user
    redirect_with_alert unless current_user.present?
  end

  def set_question_for_current_user
    @question = current_user.questions.find(params[:id])
  end
end
