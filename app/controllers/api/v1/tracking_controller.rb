class Api::V1::TrackingController < Api::BaseController

  # transaction_id={transaction_id}&
  # user_id={aff_sub2}&
  # offer_id={offer_id}&
  # id={aff_sub3}&
  # transaction={transaction_id}

  before_action :make_conversion, except: [:rubicko, :tapjoy, :game, :task_firebase, :task_wallpaper, :payu, :outside]

  def phono
    Conversion.transaction do
      @conversion.company = 'Phono'
      give_reward(Transaction::CATEGORY[:phono])
    end
  end

  def conversionx
    Conversion.transaction do
      @conversion.company = 'ConversionX'
      give_reward(Transaction::CATEGORY[:conversionx])
    end
  end

  def icubeswire
    Conversion.transaction do
      @conversion.company = 'iCubeswire'
      give_reward(Transaction::CATEGORY[:icubeswire])
    end
  end

  def vcommission
    Conversion.transaction do
      @conversion.company = 'vCommission'
      give_reward(Transaction::CATEGORY[:vcommission])
    end
  end

  #  ?userid={userid}&payout={payout}&offername={offer_name}&packagename={packagename}&offerid={offerid}&deviceid={deviceid}
  def rubicko
    Conversion.transaction do
      @conversion = Conversion.new
      offer_id = params[:offerid]
      @conversion.user_id = params[:userid]
      @conversion.transaction_id = "#{offer_id}_#{params[:userid]}"
      @conversion.company_id = params[:offerid]
      @conversion.company = 'Rubicko'
      give_reward(Transaction::CATEGORY[:rubicko], params[:payout])
    end
  end

  def instamojo
    Conversion.transaction do
      if params[:status] === 'Credit'
        @conversion = Conversion.new
        @conversion.transaction_id = params[:payment_id]
        @conversion.company = 'Instamojo'
        @conversion.company_id = params[:payment_id]
        slug = params[:offer_slug]
        product = Product.find_by_slug slug
        user = User.find_by_mobile params[:buyer_phone]
        if product and user
          @conversion.product = product
          @conversion.user = user
          give_reward(Transaction::CATEGORY[:products], product.amount)
        else
          render json: { status: true }
        end
      else
        render json: { status: true }
      end
    end
  end

  # ?snuid=<user_id>&currency=<currency>&mac_address=<mac_address>&display_multiplier=<display_multiplier>&secret_key=<secret_key>
  def tapjoy
    user = User.find_by_id params[:snuid]
    if user
      transaction = Transaction.new(
          category: Transaction::CATEGORY[:tapjoy],
          direction: Transaction::DIRECTION[:credit],
          user: user,
          from_user: user,
          from_user_status: user.status
      )
      real_amount = params[:currency].to_f / 5
      self_amount = real_amount.to_f * 0.85
      transaction.amount = self_amount
      if transaction.save
        user.wallet.add_money transaction.amount
        transaction.distribute_upline real_amount
        render status: 200 and return
      end
    end
    render status: 403
  end

  # transaction_id={click_id}&user_id={p1}&offer_id={p2}&id={p4}&transaction={click_id}&amount={sale_amount}
  def vnative
    check_conversion = Conversion.find_by_transaction_id params[:transaction_id]
    if check_conversion
      render json: { status: true } and return
    else
      @conversion = Conversion.new
      @conversion.transaction_id = params[:transaction_id]
      @conversion.user_id = params[:user_id]
      @conversion.company_id = params[:offer_id]

      check_offer = Offer.find_by_id params[:id]
      check_deal = Deal.find_by_id params[:id]

      if (check_offer&.active) or (check_deal&.active)
        if check_offer && check_offer.company_id == @conversion.company_id.to_i
          @conversion.offer_id = params[:id]

          check_offer.downloaded += 1
          if check_offer.cap > 0 && check_offer.downloaded == check_offer.cap
            check_offer.active = false
          elsif check_offer.downloaded > check_offer.cap and check_offer.cap > 0
            render json: { status: true } and return
          end

          check_offer.save
        elsif check_deal && check_deal.company_id == @conversion.company_id.to_i
          @conversion.deal_id = params[:id]

          check_deal.downloaded += 1

          if check_deal.cap > 0 && check_deal.downloaded == check_deal.cap
            check_deal.active = false
          elsif check_deal.downloaded > check_deal.cap and check_deal.cap > 0
            render json: { status: true } and return
          end

          check_deal.save
        else
          render json: { status: true } and return
        end
      else
        render json: { status: true } and return
      end
    end
    Conversion.transaction do
      @conversion.company = 'vNative'
      give_reward(Transaction::CATEGORY[:vnative], params[:amount])
    end
  end

  def game
    user = User.find_by_refer_id params[:refer_id]
    if user && params[:token] == 'e2614e2698eb3c67f125'
      real_amount = Setting.game_coins.to_f
      self_amount = real_amount.to_f * 0.85
      transaction = Transaction.new(
          category: Transaction::CATEGORY[:game2048],
          direction: Transaction::DIRECTION[:credit],
          user: user,
          from_user: user,
          from_user_status: user.status,
          amount: self_amount
      )
      if transaction.save
        user.wallet.add_money transaction.amount
        user.update(game: true, game_last: Date.today)
        transaction.distribute_upline real_amount
      end
    end

    render json: { status: true }
  end

  def task_firebase
    refer_id = params[:refer_id]
    slug_task = Task.where(slug: params[:task_id]).last
    id_task = Task.where(id: params[:task_id]).last

    if slug_task
      task = slug_task
    elsif id_task
      task = id_task
    else
      task = nil
    end

    if task&.active
      task_id = task.id
      key = params[:key]

      if key === 'f10e2485ab358ea0f1d6'
        user = User.find_by_refer_id refer_id

        if user
          reward_task = RewardTask.find_by(user: user, task_id: task_id)

          if reward_task
            render json: {status: false}
          else
            User.transaction do

              real_amount = task.amount.to_f
              self_amount = real_amount.to_f * 0.85

              transaction = Transaction.new
              transaction.user = user
              transaction.from_user = user
              transaction.from_user_status = user.status
              transaction.amount = self_amount
              transaction.category = Transaction::CATEGORY[:task]
              transaction.direction = Transaction::DIRECTION[:credit]
              transaction.data = "{task_submit_id: #{task_id}}"
              transaction.save

              transaction.distribute_upline real_amount

              reward_task = RewardTask.new
              reward_task.user = user
              reward_task.task_id = task_id
              reward_task.save

              reward_task.user.wallet.add_money transaction.amount

              task.update(downloaded: task.downloaded + 1)
              if task.cap > 0 and task.downloaded >= task.cap
                task.update(active: false)
              end

              render json: {status: true}

            end
          end
        else
          render json: { status: false }
        end
      else
        render json: { status: false }
      end
    else
      render json: { status: false }
    end
  end

  def task_wallpaper
    refer_id = params[:refer_id]
    task_id = params[:task_id]
    key = params[:key]

    if key === '0a56761f641bd58cb6c8'
      user = User.find_by_refer_id refer_id
      if user
        reward_task = RewardTask.find_by(user: user, task_id: task_id)
        if reward_task
          render json: {status: false}
        else
          User.transaction do

            task = Task.find_by_id task_id

            if task
              task_submit = TaskSubmit.new(user: user, task_id: task_id, status: TaskSubmit::STATUS[:approved])
              task_submit.save

              real_amount = task.amount
              self_amount = real_amount.to_f * 0.85

              transaction = Transaction.new
              transaction.user = user
              transaction.from_user = user
              transaction.from_user_status = user.status
              transaction.amount = self_amount
              transaction.category = Transaction::CATEGORY[:task]
              transaction.direction = Transaction::DIRECTION[:credit]
              transaction.data = "{task_submit_id: #{task_submit.id}}"
              transaction.save

              transaction.distribute_upline real_amount

              reward_task = RewardTask.new
              reward_task.user = user
              reward_task.task_id = task_id
              reward_task.save

              reward_task.user.wallet.add_money transaction.amount
              render json: {status: true}
            else
              render json: { status: false }
            end
          end
        end
      else
        render json: { status: false }
      end
    else
      render json: { status: 4 }
    end
  end

  def payu
    mobile = params[:mobile]
    user = User.find_by_mobile mobile
    key = params[:key]
    if user and key === 'd893769e89032d1f4e34bb63'
      User.transaction do
        ids = params[:products].split(',')
        ids.each do |id|
          product = Product.find_by_slug id

          if product
            real_amount = product.amount.to_f
            self_amount = real_amount.to_f * 0.85

            transaction = Transaction.new
            transaction.user = user
            transaction.from_user = user
            transaction.from_user_status = user.status
            transaction.amount = self_amount
            transaction.category = Transaction::CATEGORY[:products]
            transaction.direction = Transaction::DIRECTION[:credit]
            transaction.data = "{product_id: #{id}}"
            transaction.save

            transaction.distribute_upline real_amount
          end
        end
      end
    end
    render json: { status: true }
  end

  # task_id / slug_id
  # refer_id
  # category
  #   1 -> Task
  #   2 -> Screen Lock
  def outside
    key = params[:key]
    # 42
    category = params[:category]
    user = User.find_by_refer_id params[:refer_id]

    if user
      if category === 1 and key === '3e4f86ae8ce2c469f385ff85'
        task_identifier = params[:task_id]
        slug_task = Task.where(slug: task_identifier).last
        id_task = Task.where(id: task_identifier).last

        if slug_task
          task = slug_task
        elsif id_task
          task = id_task
        else
          task = nil
        end

        if task&.active
          reward_task = RewardTask.find_by(user: user, task_id: task.id)

          if reward_task
            render json: { status: false }
          else
            User.transaction do
              real_amount = task.amount.to_f
              self_amount = real_amount.to_f * 0.85

              transaction = Transaction.new
              transaction.user = user
              transaction.from_user = user
              transaction.from_user_status = user.status
              transaction.amount = self_amount
              transaction.category = Transaction::CATEGORY[:task]
              transaction.direction = Transaction::DIRECTION[:credit]
              transaction.data = "{task_submit_id: #{task.id}}"
              transaction.save

              transaction.distribute_upline real_amount

              reward_task = RewardTask.new
              reward_task.user = user
              reward_task.task_id = task.id
              reward_task.save

              reward_task.user.wallet.add_money transaction.amount

              task.update(downloaded: task.downloaded + 1)
              if task.cap > 0 and task.downloaded >= task.cap
                task.update(active: false)
              end

              render json: {status: true}
            end
          end
        else
          render json: { status: false }
        end
      elsif category === 2 and key === 'ba32db798250f304a6536c'
        amount = params[:coins]

        if user.wallet
          Transaction.transaction do
            t = Transaction.create(
                amount: amount,
                category: Transaction::CATEGORY[:screen_lock],
                direction: Transaction::DIRECTION[:credit],
                user: user,
                from_user: user,
                from_user_status: user.status
            )

            t.distribute_upline_lock t.amount

            user.wallet.update(screen_lock: user.wallet.screen_lock + amount)

            render json: {status: true}
          end
        else
          render json: { status: false }
        end
      elsif category === 3 and key === 'f75a6161379168348021efc3'
        amount = params[:coins]

        self_amount = amount.to_f * 0.85

        if user.wallet
          Transaction.transaction do
            t = Transaction.create(
                amount: self_amount,
                category: Transaction::CATEGORY[:spin_wheel],
                direction: Transaction::DIRECTION[:credit],
                user: user,
                from_user: user,
                from_user_status: user.status
            )

            user.wallet.add_money self_amount

            t.distribute_upline amount

            render json: {status: true}
          end
        else
          render json: { status: false }
        end
      elsif category === 4 and key === 'b390e86627919b506d5cdca7'
        amount = params[:coins]
        if amount == 500 or amount == 1000
          if amount == 500
            amount = 8
          elsif amount == 1000
            amount = 20
          else
            render json: { status: false } and return
          end

          self_amount = amount.to_f * 0.85

          if user.wallet
            Transaction.transaction do
              t = Transaction.create(
                  amount: self_amount,
                  category: Transaction::CATEGORY[:khabri_ustad],
                  direction: Transaction::DIRECTION[:credit],
                  user: user,
                  from_user: user,
                  from_user_status: user.status
              )

              user.wallet.add_money self_amount

              t.distribute_upline amount

              render json: {status: true}
            end
          else
            render json: { status: false }
          end
        else
          render json: { status: false }
        end
      else
        render json: { status: false }
      end
    else
      render json: { status: false }
    end
  end

  private

  def make_conversion
    check_conversion = Conversion.find_by_transaction_id params[:transaction_id]
    if check_conversion
      render json: { status: true } and return
    else
      @conversion = Conversion.new
      @conversion.transaction_id = params[:transaction_id]
      @conversion.user_id = params[:user_id]
      @conversion.company_id = params[:offer_id]

      check_offer = Offer.find_by_id params[:id]
      check_deal = Deal.find_by_id params[:id]

      if (check_offer&.active) or (check_deal&.active)
        if check_offer && check_offer.company_id == @conversion.company_id.to_i
          @conversion.offer_id = params[:id]

          check_offer.downloaded += 1
          if check_offer.cap > 0 && check_offer.downloaded == check_offer.cap
            check_offer.active = false
          elsif check_offer.downloaded > check_offer.cap and check_offer.cap > 0
            render json: { status: true } and return
          end

          check_offer.save
        elsif check_deal && check_deal.company_id == @conversion.company_id.to_i
          @conversion.deal_id = params[:id]

          check_deal.downloaded += 1

          if check_deal.cap > 0 && check_deal.downloaded == check_deal.cap
            check_deal.active = false
          elsif check_deal.downloaded > check_deal.cap and check_deal.cap > 0
            render json: { status: true } and return
          end

          check_deal.save
        else
          render json: { status: true } and return
        end
      else
        render json: { status: true } and return
      end
    end
  end

  def give_reward(category, amount = 0, data = '')
    if @conversion.company_id == @conversion.company_id
      @conversion.status = Conversion::STATUS[:approved]
      if @conversion.save
        user = @conversion.user
        transaction = Transaction.new(
            category: category,
            direction: Transaction::DIRECTION[:credit],
            user_id: @conversion.user_id,
            from_user_id: @conversion.user_id,
            from_user_status: user.status
        )
        if @conversion.offer
          transaction.data = "{offer_id: #{@conversion.offer_id}}"
          self_amount = @conversion.offer.amount.to_f * 0.85
          real_amount = @conversion.offer.amount.to_f
          transaction.amount = self_amount
          if @conversion.offer.reward_later
            @conversion.status = Conversion::STATUS[:unapproved]
            @conversion.save
            render json: { status: true } and return
          end
        elsif @conversion.deal
          transaction.data = "{offer_id: #{@conversion.deal_id}}"
          self_amount = @conversion.deal.amount.to_f * 0.85
          real_amount = @conversion.deal.amount.to_f
          transaction.amount = self_amount
          if @conversion.deal.reward_later
            render json: { status: true } and return
          end
        else
          self_amount = amount.to_f * 0.85
          real_amount = amount.to_f
          transaction.amount = self_amount
          transaction.data = data
        end
        if transaction.save
          transaction.user.wallet.add_money transaction.amount
          transaction.distribute_upline real_amount
        end
      end
    end
    render json: { status: true }
  end

end
