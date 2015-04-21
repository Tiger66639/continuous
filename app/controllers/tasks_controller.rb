class TasksController < ApplicationController
  before_action :set_task, only: [:show, :edit, :update, :destroy]
  before_action :checkOwner, only: [:show, :edit, :update, :destroy]
  # GET /tasks
  # GET /tasks.json
  def index
    @tasks = @current_account.tasks.all
    @task = Task.new
  end


  # GET /tasks/taskform
  def taskform
    @tform = params[:taskform]
    if @tform == "ssh"
      render "task_form_ssh", layout: false
    elsif @tform == "http"
      render "task_form_http", layout: false
    elsif @tform == "smtp"
      render "task_form_smtp", layout: false
    else
      nil
    end
  end

  # GET /tasks/1
  # GET /tasks/1.json
  def show
  end

  # GET /tasks/new
  def new
    @task = Task.new
  end

  # GET /tasks/1/edit
  def edit
  end

  # POST /tasks
  # POST /tasks.json
  def create
    @task = Task.new(task_params)

    respond_to do |format|
      if @task.save
        @current_account.tasks << @task
        format.html { redirect_to "/tasks", notice: 'Task was successfully created.' }
        format.json { render :show, status: :created, location: @task }
      else
        error_message = "Error while creating the resource "
        @task.errors.full_messages.each do |message|
          error_message += "- #{message}"
        end

        format.html { redirect_to "/tasks", notice: "#{error_message}" }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1
  # PATCH/PUT /tasks/1.json
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: 'Task was successfully updated.' }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1
  # DELETE /tasks/1.json
  def destroy
    #@task.sendDestroy
    @task.destroy
    respond_to do |format|
      format.html { redirect_to tasks_url, notice: 'Task was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_task
      @task = Task.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def task_params
      params.require(:task).permit(:name, :tasktype, :definition, :description, :taskform, :http_url, :http_method, :http_params, :http_body, :http_headers, :http_cookies, :http_auth, :http_timeout, :http_allow_redirects, :http_proxies, :smtp_to, :smtp_subject, :smtp_body, :smtp_from, :smtp_server, :smtp_password, :ssh_cmd, :ssh_host, :ssh_username, :ssh_password, :varinput)
    end

    def checkOwner
      checkObjectOwner("tasks", @task)
    end
end
