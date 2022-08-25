class QuestionsController < ApplicationController
  REGEX_HASHTAG = /#[\p{L}\d\S]+/

  before_action :ensure_current_user, only: %i[update destroy edit]
  before_action :set_question_for_current_user, only: %i[update destroy edit]

  def create
    @question = Question.new(question_params)
    @question.author = current_user

    if @question.save
      FindHastags.call(@question)
      redirect_to user_path(@question.user.nickname), notice: 'Новый вопрос создан!'
    else
      render :new
    end
  end

  def update
    if @question.update(question_params)
      FindHastags.call(@question)
    end
    redirect_to user_path(@question.user.nickname), notice: 'Сохранили вопрос!'
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

  # def new
  #   @user = User.find(params[:user_id])
  #   @question = Question.new
  # end

  def edit
  end

  private

  def question_params
    if current_user.present? && params[:question][:user_id].to_i == current_user.id
      params.require(:question).permit(:user_id, :body, :answer)
    else
      params.require(:question).permit(:user_id, :body)
    end
  end

  def ensure_current_user
    redirect_with_alert unless current_user.present?
  end

  def set_question_for_current_user
    @question = current_user.questions.find(params[:id])
  end
end
