class Admin::RedeemsController < ApplicationController

  layout 'admin'
  before_action :set_redeem, only: [:approve, :decline, :show]

  def index
    respond_to do |format|
      format.html
      format.json { render json: RedeemDatatable.new(view_context) }
    end
  end

  def export
  end

  def download_export
    data = params[:redeem]
    date = data[:date_range].split(' - ')
    from_date = Date.parse date[0]
    to_date = Date.parse date[1]
    status = data[:status]
    kind = data[:kind]

    output = Redeem.where(status: status, kind: kind).where('DATE(created_at) > DATE(?) AND DATE(created_at) < DATE(?)', from_date, to_date)
    data = []
    output.each do |redeem|
      data << {
          id: redeem.id,
          mobile: redeem.mobile,
          ifsc: redeem.ifsc,
          bank_name: redeem.bank_name,
          name: redeem.name,
          email: redeem.email,
          coins: redeem.coins,
          swift_code: redeem.swift_code,
          status: Redeem::STATUS_REVERSE[redeem.status],
          kind: Redeem::KIND_REVERSE[redeem.kind],
          created_at: redeem.created_at.in_time_zone('New Delhi').strftime('%d %b %Y %H:%M'),
          refer_id: redeem.user.refer_id,
          user: redeem.user.name
      }
    end
    send_data(data.to_xls, filename: 'export.xls')
  end

  def show
  end

  def approve
    Redeem.transaction do
      @redeem.update!(status: Redeem::STATUS[:approved])
      transaction = Transaction.new
      transaction.user = @redeem.user
      transaction.amount = -@redeem.coins
      transaction.direction = Transaction::DIRECTION[:debit]
      transaction.category = Redeem::KIND_MAPPING_TRANSACTION[@redeem.kind]
      transaction.from_user = @redeem.user
      transaction.from_user_status = @redeem.user.status
      transaction.save!

      wallet = @redeem.user.wallet
      wallet.update(total_redeem: wallet.total_redeem + transaction.amount)
    end
  end

  def decline_form
    @redeem = Redeem.find_by_id params[:id]
  end

  def decline
    Redeem.transaction do
      @redeem.update!(status: Redeem::STATUS[:rejected], reason: params[:reason])

      transaction = Transaction.new
      transaction.category = Transaction::CATEGORY[:redeem_reject]
      transaction.direction = Transaction::DIRECTION[:credit]
      transaction.amount = @redeem.coins
      transaction.user = @redeem.user
      transaction.from_user = @redeem.user
      transaction.from_user_status = @redeem.user.status
      transaction.data = "Redeem Declined: #{params[:reason]}"
      transaction.save

      wallet = @redeem.user.wallet
      wallet.update(active: wallet.active + @redeem.coins)
    end
    redirect_to admin_redeems_path
  end

  def user
    @user = User.find_by_id params[:id]
    respond_to do |format|
      format.html
      format.json { render json: RedeemDatatable.new(view_context) }
    end
  end

  private

  def set_redeem
    @redeem = Redeem.find_by_id params[:id]
  end

end
