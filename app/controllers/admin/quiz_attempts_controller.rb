class Admin::QuizAttemptsController < ApplicationController

  layout 'admin'

  before_action :set_quiz_attempt, only: [:show, :destroy]

  def index
    respond_to do |format|
      format.html
      format.json { render json: QuizAttemptDatatable.new(view_context) }
    end
  end

  def show
    @questions = @quiz_attempt.quiz_question_attempts
  end

  def destroy
    if @quiz_attempt.destroy
      flash[:success] = 'Quiz Attempt deleted'
    else
      flash[:error] = 'Please try again in sometime.'
    end
    redirect_back fallback_location: admin_quiz_attempts_path
  end

  private

  def set_quiz_attempt
    @quiz_attempt = QuizAttempt.find_by_id params[:id]
  end

end
