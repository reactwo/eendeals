namespace :users do
  desc "Deactivate users who have not activated their account within 30 days"
  task deactivate: :environment do
    last_date = Date.today - 31.days

    users = User.where('DATE(created_at) <= ? AND status = ?', last_date, User::STATUS[:verified]).order(id: :desc)
    users.each do |user|
      #   Make OldUser
      old_user = user.make_old_user

      #   1) Add OldUser to wallet and delete wallet
      begin
        user.wallet.update(old_user: old_user)
        user.wallet.destroy
      rescue
      end

      #   2) Add OldUser to transactions and delete all transactions
      begin
        user.transactions.update_all(old_user_id: old_user.id)
        user.transactions.destroy_all
      rescue
      end

      #   3) Add OldUser to task submits and delete all task submits
      begin
        user.task_submits.update_all(old_user_id: old_user.id)
        user.task_submits.destroy_all
      rescue
      end

      #   4) Add OldUser to limits and destroy all limits
      begin
        user.limits.update_all(old_user_id: old_user.id)
        user.limits.destroy_all
      rescue
      end

      #   5) AddOldUser to redeems and destroy all redeems
      begin
        user.redeems.update_all(old_user_id: old_user.id)
        user.redeems.destroy_all
      rescue
      end

      #   6) Add OldUser to quiz winners and destroy all quiz winners
      begin
        user.quiz_winners.update_all(old_user_id: old_user.id)
        user.quiz_winners.destroy_all
      rescue
      end

      #   7) Add OldUser to quiz attempts and destroy all quiz attempts
      begin
        user.quiz_attempts.update_all(old_user_id: old_user.id)
        user.quiz_attempts.destroy_all
      rescue
      end

      #   8) Add OldUser to reward tasks and destroy all reward tasks
      begin
        user.reward_tasks.update_all(old_user_id: old_user.id)
        user.reward_tasks.destroy_all
      rescue
      end

      #   9) Add OldUser to deal upload and destroy all deal uploads
      begin
        user.deal_uploads.update_all(old_user_id: old_user.id)
        user.deal_uploads.destroy_all
      rescue
      end

      #   10) Add OldUser to conversions and destroy all conversions
      begin
        user.conversions.update_all(old_user_id: old_user.id)
        user.conversions.destroy_all
      rescue
      end

      #   Make the user hollow
      user.update!(email: '', mobile: "+91#{user.refer_id}", name: 'Hollow User', real_sponsor_id: nil, authentication_token: nil, token: nil, hollow: true, created_at: DateTime.now)
    end

    User.delay.closing
  end

  task fix_wallet: :environment do
    User.where(hollow: false).each do |user|
      credit_amount = user.transactions.where(from_user_status: User::STATUS[:approved], direction: Transaction::DIRECTION[:credit]).sum(:amount)
      debit_amount1 = user.transactions.where(from_user_status: User::STATUS[:approved], direction: Transaction::DIRECTION[:debit]).where('amount < 0').sum(:amount)
      debit_amount2 = user.transactions.where(from_user_status: User::STATUS[:approved], direction: Transaction::DIRECTION[:debit]).where('amount > 0').sum(:amount)
      active = (credit_amount + debit_amount1) - debit_amount2
      wallet = user.wallet
      if wallet
        wallet.update(active: active, redeem: 0)
      end
    end
  end

  task fill_wallets: :environment do
    User.in_batches.each do |users|
      users.each do |user|
        if user.wallet
          total_earning = Transaction.where(user: user, direction: Transaction::DIRECTION[:credit]).sum(:amount)
          total_redeem = Transaction.where(user: user, direction: Transaction::DIRECTION[:debit]).sum(:amount)

          user.wallet.update(total_earning: total_earning, total_redeem: total_redeem)
        end
      end
    end
  end

  task fix_refer_ids: :environment do
    empty_users = []
    User.where('sponsor_id IS NOT NULL').in_batches.each do |users|
      users.each do |user|
        if user.sponsor.nil?
          empty_users << user.id
        end
      end
      nil
    end
    empty_users.each do |user|
      if user != 1
        refers = UserRefer.where(down_user_id: user, level: 1)
        if refers.count === 1
          user_ob = User.find user
          user_ob.update(sponsor_id: refers[0].user.refer_id)
        end
      end
    end
  end

  task convert_lc_to_ec: :environment do
    User.in_batches.each do |users|
      users.each do |user|
        User.transaction do
          wallet = user.wallet
          if wallet
            ls_coins = wallet.screen_lock
            ls_coins /= 100

            transaction = Transaction.new
            transaction.category = Transaction::CATEGORY[:sl_to_ed]
            transaction.amount = ls_coins
            transaction.user = user
            transaction.from_user = user
            transaction.from_user_status = user.status
            transaction.direction = Transaction::DIRECTION[:credit]

            if transaction.save
              wallet.add_money ls_coins
              wallet.update(screen_lock: 0)
            end
          end
        end
      end
    end
  end
end
