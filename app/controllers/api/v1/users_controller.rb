class Api::V1::UsersController < Api::BaseController

  def destroy
    current_user.authentication_token = nil
    if current_user.save
      render json: { status: true }
    else
      render json: { status: false }
    end
  end

  def create
    if params[:user] and params[:user][:access_token]

      ak_user = HTTParty.get("https://graph.accountkit.com/v1.2/me/?access_token=#{params[:user][:access_token]}")
      begin
        ak_user = JSON.parse ak_user.body
      rescue
        render json: { errors: {
            access_token: ["can't be blank"]
        } } and return
      end

      if ak_user['id']
        if User.find_by_mobile ak_user['phone']['number']
          resource = User.find_by_mobile ak_user['phone']['number']
          resource.authentication_token = nil
        else
          resource = User.new user_params
          if params[:user] and params[:user][:gender]
            if params[:user][:gender].downcase === 'male'
              resource.gender = User::GENDER[:male]
            elsif params[:user][:gender].downcase === 'female'
              resource.gender = User::GENDER[:female]
            end
          end

          resource.mobile = ak_user['phone']['number']
          resource.status = User::STATUS[:verified]
          resource.password = Devise.friendly_token
          resource.refer_id = get_refer_id
        end



        if resource.save
          render json: JSON.parse(resource.to_json)
        else
          render json: { errors: resource.errors }
        end
      else
        render json: { errors: {
            access_token: ["can't be blank"]
        } }
      end
    else
      render json: { errors: {
          access_token: ["can't be blank"]
      } }
    end
  end

  def authorize
    if params[:user] and params[:user][:access_token]
      ak_user = HTTParty.get("https://graph.accountkit.com/v1.2/me/?access_token=#{params[:user][:access_token]}")
      begin
        ak_user = JSON.parse ak_user.body
      rescue
        render json: { errors: {
            access_token: ["can't be blank"]
        } } and return
      end

      if ak_user['id']
        if User.find_by_mobile ak_user['phone']['number']
          resource = User.find_by_mobile ak_user['phone']['number']
          resource.authentication_token = nil
          resource.save
        else
          resource = {
              error: 'Invalid ID, please login again.'
          }
          render json: resource and return
        end
      else
        resource = {
            error: 'Invalid ID, please login again.'
        }
        render json: resource and return
      end
    end

    render json: JSON.parse(resource.to_json)
  end

  def show
    render json: current_user
  end

  def sponsor
    if current_user.sponsor.nil?
      real_sponsor = User.where(refer_id: params[:user][:refer_id]).last
      if real_sponsor
        if params[:user][:confirmed].nil?
          render json: { status: true, name: real_sponsor.name }
        else
          hollow_user = real_sponsor.hollow_under
          if hollow_user

            hollow_user = User.find hollow_user.down_user_id

            hollow_user.name = current_user.name
            hollow_user.mobile = current_user.mobile
            hollow_user.gender = current_user.gender
            # hollow_user.refer_id = current_user.refer_id
            hollow_user.authentication_token = current_user.authentication_token
            hollow_user.status = current_user.status
            hollow_user.token = current_user.token
            hollow_user.hollow = false
            hollow_user.real_sponsor_id = params[:user][:refer_id]
            hollow_user.created_at = current_user.created_at

            current_user.update(authentication_token: nil, refer_id: nil, mobile: nil)
            current_user.limits.update_all(user_id: nil)
            wallet = current_user.wallet
            wallet.update(user_id: nil) if wallet
            current_user.destroy

            hollow_user.save
          else
            sponsor = find_sponsor real_sponsor.refer_id
            level = 1

            User.transaction do
              current_user.update(sponsor: sponsor, real_sponsor: real_sponsor)

              t = Transaction.new(
                  amount: 5,
                  user: real_sponsor,
                  category: Transaction::CATEGORY[:refer],
                  direction: Transaction::DIRECTION[:credit],
                  from_user: current_user,
                  from_user_status: current_user.status
              )
              t.save
              wallet = real_sponsor.wallet
              if wallet
                wallet.passive += 5
                wallet.save
              end

              level_income = [7, 7, 6, 5, 4, 4, 3, 3, 3, 3]

              while sponsor
                ur = UserRefer.new(down_user: current_user, user: sponsor, level: level)
                ur.save

                t = Transaction.new(
                    amount: level_income[level - 1],
                    user: sponsor,
                    category: Transaction::CATEGORY[:refer],
                    direction: Transaction::DIRECTION[:credit],
                    from_user: current_user,
                    from_user_status: current_user.status
                )
                t.save
                wallet = sponsor.wallet
                if wallet
                  wallet.passive += level_income[level - 1]
                  wallet.save
                end

                sponsor = sponsor.sponsor
                level += 1
                if level > 10
                  break
                end
              end
            end
          end

          render json: { status: true }
        end
      else
        render json: { status: false, error: 'Sponsor not found' }
      end
    else
      render json: { status: false, error: 'You already have a sponsor' }
    end
  end

  def sponsor_ids
    ids = Setting.refer_ids.split(',')
    ids.map { |id| id.strip! }
    render json: {
        ids: ids
    }
  end

  def update
    if current_user.update(user_params)
      render json: { status: true }
    else
      render json: { status: false }
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :gender, :token)
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

  def get_refer_id
    refer_id = sprintf('%06d', rand(6**6))
    while User.where(refer_id: refer_id).count > 0
      refer_id = sprintf('%06d', rand(6**6))
    end

    refer_id
  end

end