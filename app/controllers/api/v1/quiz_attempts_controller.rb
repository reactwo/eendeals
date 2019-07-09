class Api::V1::QuizAttemptsController < Api::BaseController

  def create
    quizzes = Quiz.where('DATE(date) = ?', Date.today)
    if QuizAttempt.where('DATE(created_at) >= ? AND user_id = ?', Date.today, current_user.id).count === 1
      render json: { status: false, error: "You have already played today's quiz" }
    elsif quizzes.count > 0
      quiz = quizzes.last
      quiz_attempt = QuizAttempt.new(user: current_user, quiz: quiz)
      questions = quiz.quiz_questions.order('RAND()').last(10)
      User.transaction do
        if quiz_attempt.save
          questions.each do |question|
            q = QuizQuestionAttempt.new(quiz_attempt: quiz_attempt, quiz_question: question)
            q.save
          end
          render json: { status: true, quiz_id: quiz_attempt.id }
        else
          render json: { status: false, error: 'Please try again in sometime' }
        end
      end
    else
      render json: { status: false, error: 'There is no quiz available right now' }
    end
  end

end
