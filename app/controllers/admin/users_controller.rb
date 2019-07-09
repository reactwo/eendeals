class Admin::UsersController < ApplicationController

  layout 'admin'

  before_action :set_user, only: [:show, :update, :approve]

  def index
    respond_to do |format|
      format.html
      format.json { render json: UserDatatable.new(view_context) }
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new new_user_params
    real_sponsor = User.where(refer_id: params[:user][:real_sponsor_id]).last
    if real_sponsor
      sponsor = find_sponsor @user.real_sponsor_id
      @user.sponsor = sponsor
      @user.password = Devise.friendly_token

      if @user.save

        t = Transaction.new(
            amount: 5,
            user: real_sponsor,
            category: Transaction::CATEGORY[:refer],
            direction: Transaction::DIRECTION[:credit],
            from_user: @user,
            from_user_status: @user.status
        )
        t.save
        wallet = real_sponsor.wallet
        wallet.passive += 5
        wallet.save

        level_income = [7, 7, 6, 5, 4, 4, 3, 3, 3, 3]
        level = 1

        while sponsor
          ur = UserRefer.new(down_user: @user, user: sponsor, level: level)
          ur.save

          t = Transaction.new(
              amount: level_income[level - 1],
              user: sponsor,
              category: Transaction::CATEGORY[:refer],
              direction: Transaction::DIRECTION[:credit],
              from_user: @user,
              from_user_status: @user.status
          )
          t.save
          wallet = sponsor.wallet
          wallet.passive += level_income[level - 1]
          wallet.save

          sponsor = sponsor.sponsor
          level += 1
          if level > 10
            break
          end
        end
      else
        render 'new'
      end
    else
      @user.errors[:base] << 'Real Sponsor not found'
      render 'new'
    end
  end

  def show
  end

  def update
    if @user.update(user_params)
      flash[:success] = 'User was updated'
      redirect_to admin_user_path(@user)
    else
      flash[:error] = 'User was not updated'
      redirect_to admin_user_path(@user)
    end
  end

  def level
    @user = User.find_by_id params[:id]
    @level = params[:level]

    respond_to do |format|
      format.html
      format.json { render json: UserReferDatatable.new(view_context) }
    end
  end

  def approve
    @user.status = User::STATUS[:approved]
    if @user.save
      Transaction.activate_transactions @user.id
      flash[:success] = 'User approved'
      redirect_to admin_user_path(@user)
    else
      flash[:error] = 'User could not be approved'
      redirect_to admin_user_path(@user)
    end
  end

  def chart_data
    days = params[:days]
    start_date = Date.today - days.to_i.days
    @labels = []
    @data = []
    (start_date..Date.today).each do |day|
      @data << User.where('DATE(created_at) = ?', day).count
      @labels << day.strftime('%d-%m')
    end
    respond_to do |format|
      format.js
    end
  end

  private

  def set_user
    @user = User.find_by_id params[:id]
  end

  def user_params
    params.require(:user).permit(:name, :mobile, :email, :gender)
  end

  def new_user_params
    params.require(:user).permit(:email, :name, :mobile, :refer_id, :real_sponsor_id, :gender, :status)
  end

  def check_and_return(users)
    users.each do |user|
      if user.down_user.user_refers.where(level: 1).count < 5
        return user.down_user
      end
    end
  end

  def find_sponsor(sponsor_id)
    top_user = User.find_by_refer_id sponsor_id
    if top_user.user_refers.where(level: 1).count < 5
      top_user
    elsif top_user.user_refers.where(level: 2).count < 25
      return check_and_return top_user.user_refers.where(level: 1)
    elsif top_user.user_refers.where(level: 3).count < 125
      return check_and_return top_user.user_refers.where(level: 2)
    elsif top_user.user_refers.where(level: 4).count < 625
      return check_and_return top_user.user_refers.where(level: 3)
    elsif top_user.user_refers.where(level: 5).count < 3125
      return check_and_return top_user.user_refers.where(level: 4)
    elsif top_user.user_refers.where(level: 6).count < 15625
      return check_and_return top_user.user_refers.where(level: 5)
    elsif top_user.user_refers.where(level: 7).count < 78125
      return check_and_return top_user.user_refers.where(level: 6)
    elsif top_user.user_refers.where(level: 8).count < 390625
      return check_and_return top_user.user_refers.where(level: 7)
    elsif top_user.user_refers.where(level: 9).count < 1953125
      return check_and_return top_user.user_refers.where(level: 8)
    elsif top_user.user_refers.where(level: 10).count < 9765625
      return check_and_return top_user.user_refers.where(level: 9)
    else
      return check_and_return top_user.user_refers.where(level: 10)
    end
  end

end
