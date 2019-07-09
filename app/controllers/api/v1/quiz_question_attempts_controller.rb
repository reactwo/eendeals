class Api::V1::QuizQuestionAttemptsController < Api::BaseController

  def show
    quiz_attempt = QuizAttempt.where(id: params[:id], user: current_user).last
    if quiz_attempt
      quiz_questions = quiz_attempt.quiz_question_attempts
      questions = []
      quiz_questions.each do |quiz_question|
        questions << {
            question: quiz_question.quiz_question.slice(:question, :choice_1, :choice_2, :choice_3, :choice_4),
            quiz_question_attempt_id: quiz_question.id
        }
      end
      render json: { questions: questions }
    else
      render json: { status: false, error: 'No quiz found' }
    end
  end

  def update
    quiz_question_attempt = QuizQuestionAttempt.find_by_id params[:id]
    quiz_attempt = quiz_question_attempt.quiz_attempt
    if quiz_question_attempt and (quiz_attempt.user_id === current_user.id) and (quiz_attempt.status === QuizAttempt::STATUS[:incomplete])
      if quiz_question_attempt.update(quiz_question_attempt_params)
        correct = false
        if quiz_question_attempt.selected_choice === quiz_question_attempt.quiz_question.correct_choice.to_i
          correct = true
        end
        if quiz_attempt.quiz_question_attempts.last.id == quiz_question_attempt.id
          marks = 150
          points = 0
          quiz_attempt.quiz_question_attempts.each do |q|
            if q.selected_choice == q.quiz_question.correct_choice.to_i
              points += (marks.to_f / 30000) * (30000 - (q.time_taken * 1000))
            else
              points -= 50
            end
          end
          quiz_question_attempt.quiz_attempt.update(status: QuizAttempt::STATUS[:complete], points: points)
          render json: { status: true, finish: true, correct: correct }
        else
          render json: { status: true, finish: false, correct: correct }
        end
      else
        render json: { status: false, error: 'Please try again in sometime' }
      end
    else
      render json: { status: false, error: 'Invalid question' }
    end
  end

  private

  def quiz_question_attempt_params
    params.require(:quiz_question_attempt).permit(:selected_choice, :time_taken)
  end

end
