class Api::V1::QuizWinnersController < Api::BaseController

  def index
    last_winners = QuizWinner.last

    if last_winners
      winners = last_winners.quiz.quiz_winners.order(position: :asc)
    else
      winners = []
    end

    quiz_winners = []

    winners.each do |winner|
      quiz_winners << QuizWinnerSerializer.new(winner)
    end

    render json: { quiz_winners: quiz_winners }
  end

end
