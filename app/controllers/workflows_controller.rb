class WorkflowsController < ApplicationController
  before_action :set_workflow, only: [:show, :edit, :update, :destroy]
  before_action :checkOwner, only: [:show, :edit, :update, :destroy]
  # GET /workflows
  # GET /workflows.json
  def index
    @workflows = @current_account.workflows.all
    @workflow = Workflow.new
    @tasks = @current_account.tasks.all
  end

  # GET /workflows/1
  # GET /workflows/1.json
  def show
    @task = @current_account.tasks.all
  end

  # GET /workflows/new
  def new
    @workflow = Workflow.new
  end

  # GET /workflows/1/edit
  def edit
  end

  # POST /workflows
  # POST /workflows.json
  def create
    @workflow = Workflow.new(workflow_params)

    respond_to do |format|
      if @workflow.save
        @current_account.workflows << @workflow
        format.html { redirect_to "/workflows", notice: 'Workflow was successfully created.' }
        format.json { render :show, status: :created, location: @workflow }
      else
        format.html { redirect_to "/workflows", notice: "Error while creating the resource" }
        format.json { render json: @workflow.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /workflows/1
  # PATCH/PUT /workflows/1.json
  def update
    respond_to do |format|
      if @workflow.update(workflow_params)
        format.html { redirect_to @workflow, notice: 'Workflow was successfully updated.' }
        format.json { render :show, status: :ok, location: @workflow }
      else
        format.html { render :edit }
        format.json { render json: @workflow.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /workflows/1/reload
  def reload
    @workflow = Workflow.find(params[:id])
    @workflow.save
    render nothing: true
  end

  # GET /workflows/1/diagram
  def diagram
    @workflow = @current_account.workflows.find(params[:id])
    render layout: false
  end

  # DELETE /workflows/1
  # DELETE /workflows/1.json
  def destroy
    #@workflow.sendDestroy
    @workflow.destroy
    respond_to do |format|
      format.html { redirect_to workflows_url, notice: 'Workflow was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /workflows/addtask
  def addtask
    @workflow = @current_account.workflows.find_by_id(params[:id])
    @task = @current_account.tasks.find_by_id(params[:task])
    @step = Step.new
    @step.name = params[:stepname]
    @step.save
    if @workflow and @task
      @workflow.steps << @step
      @task.steps << @step
    end
    render :partial => "flowtasks", :locals => { :step => @workflow.steps, :workflow => @workflow }
  end

  # DELETE /workflows/deltask
  def deltask
    @workflow = @current_account.workflows.find_by_id(params[:id])
    @step = Step.find(params[:step])
    if @workflow and @step
      @step.delete 
      #tasklist = @workflow.task_ids
      #tasklist.delete_at(task.to_i) 
      #@workflow.tasks.delete_all
      #tasklist.each do |t|
      #  @workflow.tasks << Task.find(t)
      #end
    end
    render :partial => "flowtasks", :locals => { :step => @workflow.steps, :workflow => @workflow }
  end

  # POST /workflows/step/completed
  def addoncompleted
    @workflow = @current_account.workflows.find(params[:id])
        newstep = ""
    if not @workflow.nil?
      case params[:step].to_i
        when 100000000
          newstep = "succeed\n"
        when 999999999
          newstep = "fail\n"
        else
          newstep = "#{Step.find(params[:step]).name}\n"
      end
      step = @workflow.steps.find(params[:stepid])
      if not step.nil?
        if not step.oncomplete.nil?
          step.oncomplete += newstep
          step.save
        else
          step.oncomplete = newstep
          step.save
        end
      end
    end
    render :partial => "flowtasks", :locals => { :step => @workflow.steps, :workflow => @workflow }
  end

  # DELETE /workflows/step/completed
  def removeoncompleted
    @workflow = @current_account.workflows.find(params[:id])
    if not @workflow.nil?
      step = @workflow.steps.find(params[:stepid])
      if not step.nil?
        a = step.oncomplete.split("\n")
        a.delete_at(params[:stepline].to_i)
        if a.size > 0
          step.oncomplete = a.join("\n")
        else
          step.oncomplete = nil
        end
        step.save
      end
    end
    render :partial => "flowtasks", :locals => { :step => @workflow.steps, :workflow => @workflow }
  end

  # POST /workflows/step/success
  def addonsuccess
    @workflow = @current_account.workflows.find(params[:id])
    newstep = ""
    if not @workflow.nil?
      case params[:step].to_i
        when 100000000
          newstep = "succeed\n"
        when 999999999
          newstep = "fail\n"
        else
          newstep = "#{Step.find(params[:step]).name}\n"
      end
      step = @workflow.steps.find(params[:stepid])
      if not step.nil?
        if not step.onsuccess.nil?
          step.onsuccess += newstep
          step.save
        else
          step.onsuccess = newstep
          step.save
        end
      end
    end
    render :partial => "flowtasks", :locals => { :step => @workflow.steps, :workflow => @workflow }
  end

  # DELETE /workflows/step/success
  def removeonsuccess
    @workflow = @current_account.workflows.find(params[:id])
    if not @workflow.nil?
      step = @workflow.steps.find(params[:stepid])
      if not step.nil?
        a = step.onsuccess.split("\n")
        a.delete_at(params[:stepline].to_i) 
        if a.size > 0 
          step.onsuccess = a.join("\n")
        else
          step.onsuccess = nil
        end
        step.save
      end
    end
    render :partial => "flowtasks", :locals => { :step => @workflow.steps, :workflow => @workflow }
  end

  # POST /workflows/step/failure
  def addonfailure
    @workflow = @current_account.workflows.find(params[:id])
    newstep = ""
    if not @workflow.nil?
      case params[:step].to_i
        when 100000000
          newstep = "succeed\n"
        when 999999999
          newstep = "fail\n"
        else
          newstep = "#{Step.find(params[:step]).name}\n"
      end
      step = @workflow.steps.find(params[:stepid])
      if not step.nil?
        if not step.onfail.nil?
          step.onfail += newstep
          step.save
        else
          step.onfail = newstep
          step.save
        end
      end
    end
    render :partial => "flowtasks", :locals => { :step => @workflow.steps, :workflow => @workflow }
  end

  # DELETE /workflows/step/failure
  def removeonfailure
    @workflow = @current_account.workflows.find(params[:id])
    if not @workflow.nil?
      step = @workflow.steps.find(params[:stepid])
      if not step.nil?
        a = step.onfail.split("\n")
        a.delete_at(params[:stepline].to_i)
        if a.size > 0
          step.onfail = a.join("\n")
        else
          step.onfail = nil
        end
        step.save
      end
    end
    render :partial => "flowtasks", :locals => { :step => @workflow.steps, :workflow => @workflow }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_workflow
      @workflow = Workflow.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def workflow_params
      params.require(:workflow).permit(:name, :definition, :description, :workflowtype)
    end

    def checkOwner
      checkObjectOwner("workflows", @workflow)
    end
end
