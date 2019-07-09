class Admin::TaskSubmitsController < ApplicationController

  layout 'admin'

  before_action :set_task_submit, only: [:show, :approve, :unapprove, :destroy]

  def index
    respond_to do |format|
      format.html
      format.json { render json: TaskSubmitDatatable.new(view_context) }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.js
    end
  end

  def approve
    @task_submit.status = TaskSubmit::STATUS[:approved]
    if @task_submit.save
      if @task_submit.task.active
        transaction = Transaction.new
        transaction.user = @task_submit.user
        transaction.from_user = @task_submit.user
        transaction.from_user_status = @task_submit.user.status
        transaction.amount = @task_submit.task.amount
        transaction.category = Transaction::CATEGORY[:task]
        transaction.direction = Transaction::DIRECTION[:credit]
        transaction.data = "{task_submit_id: #{@task_submit.id}}"
        transaction.save!
        @task_submit.user.wallet.add_money transaction.amount

        respond_to do |format|
          format.html {
            flash[:success] = 'Task submission approved'
            redirect_back fallback_location: admin_task_submits_path
          }
          format.js { @status = true }
        end
      else
        respond_to do |format|
          format.html {
            flash[:success] = 'Task is inactive'
            redirect_back fallback_location: admin_task_submits_path
          }
          format.js { @status = false }
        end
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = 'Task submission could not be approved'
          redirect_to admin_task_submit_path(@task_submit)
        }
        format.js { @status = false }
      end

    end
  end

  def unapprove
    @task_submit.status = TaskSubmit::STATUS[:unapproved]
    if @task_submit.save
      transaction = Transaction.new
      transaction.user = @task_submit.user
      transaction.from_user = @task_submit.user
      transaction.from_user_status = @task_submit.user.status
      transaction.amount = -@task_submit.task.amount
      transaction.category = Transaction::CATEGORY[:task]
      transaction.direction = Transaction::DIRECTION[:debit]
      transaction.data = "{task_submit_id: #{@task_submit.id}}"
      transaction.save!
      @task_submit.user.wallet.deduct_money @task_submit.task.amount

      respond_to do |format|
        format.html {
          flash[:success] = 'Task submission unapproved'
          redirect_back fallback_location: admin_task_submits_path
        }
        format.js { @status = true }
      end
    else
      respond_to do |format|
        format.html {
          flash[:error] = 'Task submission could not be unapproved'
          redirect_to admin_task_submit_path(@task_submit)
        }
        format.js { @status = false }
      end
    end
  end

  def destroy
    if @task_submit.destroy
      flash[:success] = 'Task submission deleted'
    else
      flash[:error] = 'Task submission cannot be deleted, please try again in sometime'
    end
    redirect_back fallback_location: admin_task_submits_path
  end

  private

  def set_task_submit
    @task_submit = TaskSubmit.find_by_id params[:id]
  end

end
