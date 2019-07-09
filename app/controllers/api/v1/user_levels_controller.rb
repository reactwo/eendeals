class Api::V1::UserLevelsController < Api::BaseController

  def index
    data = []
    (1..10).each do |level|
      data << current_user.user_refers.where(level: level).count
    end

    render json: data
  end

  def show
    render json: current_user.user_refers.where(level: params[:id]).paginate(per_page: 20, page: params[:page])
  end

  def upline
    sponsors = []
    level = 0
    sponsor = current_user.sponsor
    while level < 6 && sponsor
      # sponsors << sponsor.slice(:id, :mobile, :refer_id, :name, :gender)
      a = JSON.parse!(UserSerializer.new(sponsor).to_json).slice('id', 'mobile', 'refer_id', 'name', 'gender')
      sponsors << a
      level += 1
      sponsor = sponsor.sponsor
    end

    render json: {
        upline: sponsors
    }
  end

  def search
    name = params[:user_level][:name]
    users = current_user.user_refers.joins(:down_user).where('users.name LIKE ?', "%#{name}%").paginate(per_page: 20, page: params[:page])
    render json: users
  end

end
