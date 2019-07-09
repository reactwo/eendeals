class Admin::TransactionsController < ApplicationController

  layout 'admin'

  def all
    respond_to do |format|
      format.html
      format.json { render json: TransactionDatatable.new(view_context) }
    end
  end

  def index
    respond_to do |format|
      format.html
      format.json { render json: TransactionDatatable.new(view_context) }
    end
  end

  def credit
    @transaction = Transaction.new
  end

  def credit_save
    Transaction.transaction do
      user = User.find_by_id params[:id]
      if user
        @transaction = Transaction.new custom_transaction_params
        @transaction.direction = Transaction::DIRECTION[:credit]
        @transaction.user = user
        @transaction.from_user = user
        @transaction.from_user_status = user.status
        if @transaction.save
          user.wallet.add_money @transaction.amount
          flash[:success] = "User credited with amount #{@transaction.amount}"
          redirect_to admin_user_path(user)
        else
          render 'credit'
        end
      else
        flash[:error] = 'User not found'
        redirect_to admin_users_path
      end
    end
  end

  def debit
    @transaction = Transaction.new
  end

  def debit_save
    Transaction.transaction do
      user = User.find_by_id params[:id]
      if user
        @transaction = Transaction.new custom_transaction_params
        amount = @transaction.amount
        @transaction.amount = -@transaction.amount
        @transaction.direction = Transaction::DIRECTION[:credit]
        @transaction.user = user
        @transaction.from_user = user
        @transaction.from_user_status = user.status
        if @transaction.save
          user.wallet.deduct_money amount
          flash[:success] = "User debited with amount #{@transaction.amount}"
          redirect_to admin_user_path(user)
        else
          render 'credit'
        end
      else
        flash[:error] = 'User not found'
        redirect_to admin_users_path
      end
    end
  end

  private

  def custom_transaction_params
    params.require(:transaction).permit(:amount, :category, :data)
  end

end
