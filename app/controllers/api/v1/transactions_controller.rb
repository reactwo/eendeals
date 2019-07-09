class Api::V1::TransactionsController < Api::BaseController

  def video1
    limit = get_limit
    if limit.video1 < Setting.ppv1_limit.to_i
      limit.video1 += 1
      limit.save

      real_amount = Setting.ppv1_amount.to_f
      self_amount = real_amount.to_f * 0.85

      transaction = Transaction.create(
                     user: current_user,
                     direction: Transaction::DIRECTION[:credit],
                     category: Transaction::CATEGORY[:video1],
                     amount: self_amount,
                     from_user: current_user,
                     from_user_status: current_user.status
      )
      transaction.user.wallet.add_money transaction.amount
      transaction.distribute_upline real_amount

      render json: limit and return
    end
    render json: {
        status: false
    }
  end

  def video2
    limit = get_limit
    if limit.video2 < Setting.ppv2_limit.to_i
      limit.video2 += 1
      limit.save

      real_amount = Setting.ppv2_amount.to_f
      self_amount = real_amount.to_f * 0.85

      transaction = Transaction.create(
          user: current_user,
          direction: Transaction::DIRECTION[:credit],
          category: Transaction::CATEGORY[:video2],
          amount: self_amount,
          from_user: current_user
      )
      transaction.user.wallet.add_money transaction.amount
      transaction.distribute_upline real_amount

      render json: limit and return
    end
    render json: {
        status: false
    }
  end

  def active
    transactions = Transaction.where(user: current_user, from_user_status: User::STATUS[:approved]).order(created_at: :desc)
    serialized = []
    transactions.each do |transaction|
      serialized << TransactionSerializer.new(transaction)
    end
    render json: { transactions: serialized }
  end

  def passive
    transactions = Transaction.where(user: current_user, from_user_status: User::STATUS[:verified]).order(created_at: :desc)
    serialized = []
    transactions.each do |transaction|
      serialized << TransactionSerializer.new(transaction)
    end
    render json: { transactions: serialized }
  end

  def screen_lock
    transactions = Transaction.where(user: current_user, category: Transaction::CATEGORY[:screen_lock]).order(created_at: :desc)
    serialized = []
    transactions.each do |transaction|
      serialized << TransactionSerializer.new(transaction)
    end
    render json: { transactions: serialized }
  end

end
