class Admin::QuizWinnersController < ApplicationController

  layout 'admin'

  def index
    respond_to do |format|
      format.html { @winners = QuizWinner.all }
      format.json { render json: QuizWinnerDatatable.new(view_context) }
    end
  end

  def show
  end

end
