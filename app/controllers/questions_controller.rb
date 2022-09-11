class QuestionsController < ApplicationController
  REGEX_HASHTAG = /#[\p{L}\d\S]+/

  before_action :ensure_current_user, only: %i[update destroy edit]
  before_action :set_question_for_current_user, only: %i[update destroy edit]
  before_action :authorization_verification_user, except: %i[show index create]
  before_action :block_user_id_changes, except: %i[update]

  def create
    @question = Question.new(question_params)
    @question.author = current_user

    if check_captcha(@question) && @question.save
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

    redirect_to user_path(@user.nickname), notice: 'Вопрос удалён!'
  end

  def show
    @question = Question.find(params[:id])
  end

  def index
    @hashtags = Hashtag.all
    @questions = Question.order(created_at: :asc).last(10)
    @users = User.order(created_at: :asc).last(10)
  end

  def edit
  end

  private

  def block_user_id_changes
    redirect_to root_url, alert: 'Нельзя менять адресата вопроса' unless params[:question][:user_id] == @question.user_id
  end

  def authorization_verification_user
    redirect_to root_url, alert: 'Нет доступа' unless @question.user == current_user
  end

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

  def check_captcha(model)
    if current_user.present?
      true
    else
      verify_recaptcha(model: model)
    end
  end
end
