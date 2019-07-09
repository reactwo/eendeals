class Admin::QuizQuestionsController < ApplicationController

  layout 'admin'

  before_action :set_quiz_question, only: [:edit, :update]

  def index
    @quiz_question = QuizQuestion.new
    respond_to do |format|
      format.html
      format.json { render json: QuizQuestionDatatable.new(view_context) }
    end
  end

  def create
    uploaded_io = params[:quiz_question][:file]
    dest = Rails.root.join('tmp', uploaded_io.original_filename)

    File.open(dest, 'wb') do |file|
      file.write(uploaded_io.read)
    end


    if File.extname(dest) == '.xlsx' or File.extname(dest) == '.xls'
      xls = Roo::Spreadsheet.open dest.to_s

      xls.default_sheet = xls.sheets.first

      xls.each_row_streaming do |row|
        if row.first.to_s === 'Question'
          next
        end

        q = Quiz.find_or_create_by(date: row.last.to_s)
        if q.new_record?
          q.save
        end

        question = QuizQuestion.new
        question.question = row[0].to_s
        question.choice_1 = row[1].to_s
        question.choice_2 = row[2].to_s
        question.choice_3 = row[3].to_s
        question.choice_4 = row[4].to_s
        question.correct_choice = row[5].to_s
        question.quiz = q
        question.save
      end
    end

    redirect_to admin_quiz_questions_path
  end

  def edit
  end

  def update
    if @quiz_question.update(quiz_question_params)
      redirect_to admin_quiz_questions_path
    else
      redirect_back fallback_location: admin_quiz_questions_path
    end
  end

  private

  def set_quiz_question
    @quiz_question = QuizQuestion.find_by_id params[:id]
  end

  def quiz_question_params
    params.require(:quiz_question).permit(:question, :choice_1, :choice_2, :choice_3, :choice_4, :correct_choice)
  end

end
