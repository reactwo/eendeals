class Admin::WalletsController < ApplicationController

  layout 'admin'

  def new_csv
  end

  def create_csv
    uploaded_io = params[:wallet][:file]
    dest = Rails.root.join('tmp', uploaded_io.original_filename)

    File.open(dest, 'wb') do |file|
      file.write(uploaded_io.read)
    end


    if File.extname(dest) == '.xlsx' or File.extname(dest) == '.xls'
      xls = Roo::Spreadsheet.open dest.to_s

      xls.default_sheet = xls.sheets.first

      xls.each_row_streaming do |row|
        if row.first.to_s === 'Refer ID'
          next
        end

        user = User.find_by_refer_id row[0].to_s
        if user
          wallet = user.wallet

          if wallet
            active_deduct = row[1].to_s.to_f
            active_add = row[2].to_s.to_f
            active_set = row[3].to_s

            redeem_deduct = row[4].to_s.to_f
            redeem_add = row[5].to_s.to_f
            redeem_set = row[6].to_s

            passive_deduct = row[7].to_s.to_f
            passive_add = row[8].to_s.to_f
            passive_set = row[9].to_s

            if active_set != 'NA'
              active_set = active_set.to_f
              if active_deduct === 0 and active_add === 0 and active_set === 0
                wallet.update(active: 0)
              elsif active_deduct > 0
                wallet.update(active: wallet.active - active_deduct, total_earning: wallet.total_earning - active_deduct)
              elsif active_add > 0
                wallet.update(active: wallet.active + active_add, total_earning: wallet.total_earning + active_add)
              elsif active_set > 0
                wallet.update(active: active_set)
              end
            end

            if redeem_set != 'NA'
              if redeem_deduct === 0 and redeem_add === 0 and redeem_set === 0
                wallet.update(redeem: 0)
              elsif redeem_deduct > 0
                wallet.update(redeem: wallet.redeem - redeem_deduct, total_redeem: wallet.total_redeem - redeem_deduct)
              elsif redeem_add > 0
                wallet.update(redeem: wallet.redeem + redeem_add, total_redeem: wallet.total_redeem + redeem_add)
              elsif redeem_set > 0
                wallet.update(redeem: redeem_set)
              end
            end

            if passive_set != 'NA'
              if passive_deduct === 0 and passive_add === 0 and passive_set === 0
                wallet.update(passive: 0)
              elsif passive_deduct > 0
                wallet.update(passive: wallet.passive - passive_deduct, total_earning: wallet.total_earning - passive_deduct)
              elsif passive_add > 0
                wallet.update(passive: wallet.passive + passive_add, total_earning: wallet.total_earning + passive_add)
              elsif passive_set > 0
                wallet.update(passive: passive_set)
              end
            end
          else
            next
          end
        else
          next
        end
      end
    end

    redirect_to admin_users_path
  end

  def daily_csv
  end

  def create_daily_csv
    uploaded_io = params[:wallet][:file]
    dest = Rails.root.join('tmp', uploaded_io.original_filename)

    File.open(dest, 'wb') do |file|
      file.write(uploaded_io.read)
    end


    if File.extname(dest) == '.xlsx' or File.extname(dest) == '.xls'
      xls = Roo::Spreadsheet.open dest.to_s

      xls.default_sheet = xls.sheets.first

      xls.each_row_streaming do |row|
        if row.first.to_s === 'Refer ID'
          next
        end

        user = User.find_by_refer_id row[0].to_s
        if user
          wallet = user.wallet

          if wallet
            screen_lock_add = row[1].to_s.to_f
            screen_lock_deduct = row[2].to_s.to_f
            screen_lock_set = row[3].to_s.to_f

            Transaction.transaction do
              if screen_lock_deduct === 0 and screen_lock_add === 0 and screen_lock_set === 0
                # set 0
                Transaction.create(
                  amount: -wallet.screen_lock,
                  category: Transaction::CATEGORY[:screen_lock],
                  direction: Transaction::DIRECTION[:debit],
                  user: wallet.user,
                  from_user: wallet.user,
                  from_user_status: wallet.user.status
                  )

                wallet.update(screen_lock: 0)
              elsif screen_lock_deduct > 0
                # deduction
                Transaction.create(
                  amount: -screen_lock_deduct,
                  category: Transaction::CATEGORY[:screen_lock],
                  direction: Transaction::DIRECTION[:debit],
                  user: wallet.user,
                  from_user: wallet.user,
                  from_user_status: wallet.user.status
                  )

                wallet.update(screen_lock: wallet.screen_lock - screen_lock_deduct)
              elsif screen_lock_add > 0
                # addition
                t = Transaction.create(
                  amount: screen_lock_add,
                  category: Transaction::CATEGORY[:screen_lock],
                  direction: Transaction::DIRECTION[:credit],
                  user: wallet.user,
                  from_user: wallet.user,
                  from_user_status: wallet.user.status
                  )

                t.distribute_upline_lock t.amount

                wallet.update(screen_lock: wallet.screen_lock + screen_lock_add)
                user.update(lock: true, lock_last: Date.today)
              end
            end
          else
            next
          end
        end
      end
    end

    redirect_to admin_users_path
  end

  def khabri_csv
  end

  def create_khabri_csv
    uploaded_io = params[:wallet][:file]
    dest = Rails.root.join('tmp', uploaded_io.original_filename)

    File.open(dest, 'wb') do |file|
      file.write(uploaded_io.read)
    end


    if File.extname(dest) == '.xlsx' or File.extname(dest) == '.xls'
      xls = Roo::Spreadsheet.open dest.to_s

      xls.default_sheet = xls.sheets.first

      xls.each_row_streaming do |row|
        if row.first.to_s === 'Refer ID'
          next
        end

        user = User.find_by_refer_id row[0].to_s
        if user
          wallet = user.wallet

          if wallet
            coins = row[1].to_s.to_f
            if coins == 500
              coins = 8
            elsif coins == 1000
              coins = 20
            else
              next
            end

            real_amount = coins
            self_amount = real_amount.to_f * 0.85

            transaction = Transaction.new
            transaction.user = user
            transaction.from_user = user
            transaction.from_user_status = user.status
            transaction.amount = self_amount
            transaction.category = Transaction::CATEGORY[:khabri_ustad]
            transaction.direction = Transaction::DIRECTION[:credit]
            transaction.save

            transaction.distribute_upline real_amount

            wallet.add_money transaction.amount
          else
            next
          end
        end
      end
    end

    redirect_to admin_users_path
  end

end