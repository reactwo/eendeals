class Admin::DashboardController < ApplicationController

  layout 'admin'

  def index
    @date = Date.today.strftime('%d-%m')
    @user_count = User.where('created_at >= ?', Date.today).count
  end

  def closing
    # User.delay.closing
    flash[:success] = 'Closing calculation started'
    redirect_to admin_path
  end

  def quiz_winner
  end

  def choose_quiz_winners
    date = Date.parse "#{params[:quiz]['date(1i)']}/#{params[:quiz]['date(2i)']}/#{params[:quiz]['date(3i)']}"
    quiz = Quiz.where('DATE(date) = ?', date).last

    if quiz.quiz_winners.count > 0
      flash[:error] = 'Winners already selected for this quiz'
    else
      first_place = params[:quiz][:first_prize]
      second_place = params[:quiz][:second_prize]
      third_place = params[:quiz][:third_prize]


      first_place_winners = QuizAttempt.where('DATE(created_at) = ?', date).order(points: :desc).limit first_place
      first_place_last = first_place_winners.count > 0 ? first_place_winners.last.points : 1500

      second_place_winners = QuizAttempt.where('DATE(created_at) = ? AND points < ?', date, first_place_last).order(points: :desc).limit(second_place)
      second_place_last = (
      if second_place_winners.count > 0
        second_place_winners.last.points
      else
        first_place_winners.count > 0 ? first_place_last : 1500
      end
      )

      third_place_winners = QuizAttempt.where('DATE(created_at) = ? and points < ?', date, second_place_last).order(points: :desc).limit(third_place)

      total_winners = params[:quiz][:winners].to_i
      remaining_winners = total_winners - (first_place_winners.count + second_place_winners.count + third_place_winners.count)

      first_place_winners.each do |fpw|
        quiz_winner = QuizWinner.new(user: fpw.user, points: fpw.points, quiz: fpw.quiz, position: 1)
        quiz_winner.save!
      end

      second_place_winners.each do |spw|
        quiz_winner = QuizWinner.new(user: spw.user, points: spw.points, quiz: spw.quiz, position: 2)
        quiz_winner.save!
      end

      third_place_winners.each do |tpw|
        quiz_winner = QuizWinner.new(user: tpw.user, points: tpw.points, quiz: tpw.quiz, position: 2)
        quiz_winner.save!
      end

      dummy_winners = [200]
      max_points = 1500

      while remaining_winners > 0
        dummy = User.where('id >= 1 AND id <= 156 AND id NOT IN (?)', dummy_winners).order('RAND()').limit(1).last

        position = rand(1..3)

        quiz_winner = QuizWinner.new(user: dummy, points: 0, quiz: quiz, position: position)
        quiz_winner.save!

        remaining_winners -= 1
      end

      flash[:success] = 'Winners selected'
    end
    redirect_to admin_quiz_winners_path
  end

end
