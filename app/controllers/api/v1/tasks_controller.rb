class Api::V1::TasksController < Api::BaseController

  def index
    task_submits = current_user.task_submits.count > 0 ? current_user.task_submits.pluck(:task_id) : ''
    render json: Task.where('id NOT IN (?) AND active = 1 AND ((UNIX_TIMESTAMP(start_time) < UNIX_TIMESTAMP(?) AND UNIX_TIMESTAMP(end_time) > UNIX_TIMESTAMP(?)) || (start_time IS NULL AND end_time IS NULL))', task_submits, DateTime.now, DateTime.now).
        order(id: :asc).
        paginate(per_page: 9, page: params[:page])
  end

  def submit
    Task.transaction do
      old_task = TaskSubmit.where(task_id: params[:id], user_id: current_user.id)
      if old_task.count === 0
        task_submit = TaskSubmit.new task_submit_params
        task = Task.find_by_id params[:id]

        if task.active
          task_submit.user = current_user
          task_submit.task = task
          if task_submit.save
            # task = task_submit.task
            # task.downloaded += 1
            # if task.cap > 0 && task.downloaded == task.cap
            #   task.active = false
            # end
            # task.save
            render json: { status: true }
          else
            render json: { status: false }
          end
        else
          render json: { status: true }
        end
      else
        render json: { status: true }
      end
    end
  end

  private

  def task_submit_params
    params.require(:task_submit).permit(:image)
  end

end
