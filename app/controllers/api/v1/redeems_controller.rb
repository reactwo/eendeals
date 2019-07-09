class Api::V1::RedeemsController < Api::BaseController

  before_action :check_redeem, except: :check_time

  def check_time
    now = DateTime.now.in_time_zone('New Delhi')
    # now = DateTime.commercial(2017, 1, 1, 21, 0, 0, '+05:30').in_time_zone('New Delhi')
    hour = now.hour
    # render json: { status: false, date: now }
    render json: { status: (hour >= 21 && hour <= 23), date: now }
    # render json: { status: true, date: now }
  end

  def paypal
    redeem = Redeem.new paypal_params
    redeem.kind = Redeem::KIND[:paypal]
    redeem.user = current_user
    redeem.status = Redeem::STATUS[:submitted]
    if redeem.user.wallet.active >= redeem.coins
      if redeem.save
        redeem.user.wallet.update(active: redeem.user.wallet.active - redeem.coins)
        render json: { status: true, message: 'Your request has been sent to the admin.' }
      else
        render json: { status: false, message: 'There was some error, please try again in sometime' }
      end
    else
      render json: { status: false, message: 'You don\'t have enough balance' }
    end
  end

  def paytm
    redeem = Redeem.new paytm_params
    redeem.kind = Redeem::KIND[:paytm]
    redeem.user = current_user
    redeem.status = Redeem::STATUS[:submitted]
    if redeem.user.wallet.active >= redeem.coins
      if redeem.save
        redeem.user.wallet.update(active: redeem.user.wallet.active - redeem.coins)
        render json: { status: true, message: 'Your request has been sent to the admin.' }
      else
        render json: { status: false, message: 'There was some error, please try again in sometime' }
      end
    else
      render json: { status: false, message: 'You don\'t have enough balance' }
    end
  end

  def bank
    redeem = Redeem.new bank_params
    redeem.kind = Redeem::KIND[:bank]
    redeem.user = current_user
    redeem.status = Redeem::STATUS[:submitted]
    if redeem.user.wallet.active >= redeem.coins
      if redeem.save
        redeem.user.wallet.update(active: redeem.user.wallet.active - redeem.coins)
        render json: { status: true, message: 'Your request has been sent to the admin.' }
      else
        render json: { status: false, message: 'There was some error, please try again in sometime' }
      end
    else
      render json: { status: false, message: 'You don\'t have enough balance' }
    end
  end

  def payza
    redeem = Redeem.new paypal_params
    redeem.kind = Redeem::KIND[:payza]
    redeem.user = current_user
    redeem.status = Redeem::STATUS[:submitted]
    if redeem.user.wallet.active >= redeem.coins
      if redeem.save
        redeem.user.wallet.update(active: redeem.user.wallet.active - redeem.coins)
        render json: { status: true, message: 'Your request has been sent to the admin.' }
      else
        render json: { status: false, message: 'There was some error, please try again in sometime' }
      end
    else
      render json: { status: false, message: 'You don\'t have enough balance' }
    end
  end

  def bkash
    redeem = Redeem.new bkash_params
    redeem.kind = Redeem::KIND[:bkash]
    redeem.user = current_user
    redeem.status = Redeem::STATUS[:submitted]
    if redeem.user.wallet.active >= redeem.coins
      if redeem.save
        redeem.user.wallet.update(active: redeem.user.wallet.active - redeem.coins)
        render json: { status: true, message: 'Your request has been sent to the admin.' }
      else
        render json: { status: false, message: 'There was some error, please try again in sometime' }
      end
    else
      render json: { status: false, message: 'You don\'t have enough balance' }
    end
  end

  def ed_ads
    redeem = Redeem.new ed_ads_params
    redeem.user = current_user
    redeem.kind = Redeem::KIND[:ed_ads]
    redeem.status = Redeem::STATUS[:submitted]
    if redeem.user.wallet.active >= redeem.coins
      if redeem.save
        redeem.user.wallet.update(active: redeem.user.wallet.active - redeem.coins)
        response = RestClient.post('http://vistagain.com/khabri_ustaad/api/transfer.php',
                                   {
                                       user_id: current_user.id,
                                       amount: redeem.coins.to_f,
                                       title: 'Eendeals Ed Ads Redeem'
                                   },
                                   {
                                       secret: 'fdsagr234@#@sfa',
                                       'Content-Type': 'multipart/form-data'
                                   }
        )
        if response.body.split(',')[0] == '1'
          render json: { status: true, message: 'Your request has been sent to the admin.' }
        else
          redeem.destroy
          render json: { status: true, message: 'There was some error, please try again in sometime.' }
        end
      else
        render json: { status: true, message: 'There was some error, please try again in sometime.' }
      end
    else
      render json: { status: false, message: "You don't have enough balance." }
    end
  end

  private

  def paypal_params
    params.require(:redeem).permit(:email, :coins)
  end

  def paytm_params
    params.require(:redeem).permit(:mobile, :coins)
  end

  def bank_params
    params.require(:redeem).permit(:account_no, :ifsc, :bank_name, :name, :swift_code, :coins)
  end

  def bkash_params
    params.require(:redeem).permit(:account_no, :email, :mobile, :coins)
  end

  def ed_ads_params
    params.require(:redeem).permit(:coins)
  end

  def check_redeem
    if current_user.redeems.count > 0
      redeem = current_user.redeems.order(id: :asc).last
      if redeem.created_at.month === Date.today.month and redeem.created_at.day === Date.today.day
        render json: { status: false, message: 'You can only redeem once in a month' } and return
      end
    end
  end

end
