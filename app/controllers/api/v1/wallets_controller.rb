class Api::V1::WalletsController < Api::BaseController

  def index
    wallet = current_user.wallet
    if wallet.nil?
      wallet = Wallet.create(active: 0, passive: 0, user: current_user)
    end
    render json: wallet
  end

end
