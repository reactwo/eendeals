class Admin::TasksController < ApplicationController

  layout 'admin'

  before_action :set_task, only: [:show, :edit, :update, :destroy]

  def index
    respond_to do |format|
      format.html
      format.json { render json: TaskDatatable.new(view_context) }
    end
  end

  def show
  end

  def new
    @task = Task.new
  end

  def new_csv
  end

  def create_csv
    uploaded_io = params[:task][:file]
    dest = Rails.root.join('tmp', uploaded_io.original_filename)

    File.open(dest, 'wb') do |file|
      file.write(uploaded_io.read)
    end


    if File.extname(dest) == '.xlsx' or File.extname(dest) == '.xls'
      xls = Roo::Spreadsheet.open dest.to_s

      xls.default_sheet = xls.sheets.first

      xls.each_row_streaming do |row|
        if row.first.to_s === 'Name'
          next
        end

        task = Task.new
        task.name = row[0].to_s
        task.instructions = row[1].to_s
        task.amount = row[2].to_s.to_f
        task.link = row[3].to_s
        task.active = row[4].to_s.to_i
        task.cap = row[5].to_s.to_i
        task.picture_upload = row[6].to_s.to_i
        task.run_days = row[7].to_s.to_i
        task.start_time = DateTime.strptime(row[8].to_s, '%d/%m/%Y %H:%M')
        task.end_time = DateTime.strptime(row[9].to_s, '%d/%m/%Y %H:%M')
        task.slug = row[10].to_s
        task.save

        if task.run_days > 1
          tomorrow = Date.today + 1.day
          running_time = DateTime.new(tomorrow.year, tomorrow.month, tomorrow.day)
          task.delay(run_at: running_time).run_consecutive
        end
      end
    end

    redirect_to admin_tasks_path
  end

  def create
    @task = Task.new task_params
    if @task.save
      @task.parent_id = @task.id
      @task.save
      if @task.run_days > 1
        tomorrow = Date.today + 1.day
        running_time = DateTime.new(tomorrow.year, tomorrow.month, tomorrow.day)
        @task.delay(run_at: running_time).run_consecutive
      end
      flash[:success] = 'Task saved'
      redirect_to admin_tasks_path
    else
      flash[:error] = 'Please try again'
      render 'new'
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      flash[:success] = 'Task updated'
      redirect_to admin_task_path(@task)
    else
      flash[:error] = 'Please try again'
      render 'edit'
    end
  end

  def destroy
    if @task.destroy
      flash[:error] = 'Task deleted'
      redirect_to admin_tasks_path
    else
      flash[:error] = 'Please try again'
      redirect_back fallback_location: admin_task_path(@task)
    end
  end

  private

  def task_params
    params.require(:task).permit(:name, :instructions, :amount, :link, :active, :cap, :picture_upload, :run_days, :start_time, :end_time, :slug)
  end

  def set_task
    @task = Task.find_by_id params[:id]
  end

end
