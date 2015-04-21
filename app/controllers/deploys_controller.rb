class DeploysController < ApplicationController
  before_action :set_deploy, only: [:show, :edit, :update, :destroy]

  # GET /deploys
  # GET /deploys.json
  def index
    @deploys = Deploy.all
    @deploy = Deploy.new
    @workflows = @current_account.workflows
  end

  # GET /deploys/1
  # GET /deploys/1.json
  def show
    @deploy.getWorkflowInMistral
    @deploy.save
    @listTasks = @deploy.getTasksInMistral
  end

  # GET /deploys/new
  def new
    @deploy = Deploy.new
    @workflows = @current_account.workflows
  end

  # GET /deploys/1/edit
  def edit
  end

  # POST /deploys
  # POST /deploys.json
  def create
    @deploy = Deploy.new(deploy_params)
    @deploy.deployinput= params[:deploy][:deployinput]
    respond_to do |format|
      if @deploy.save
        format.html { redirect_to "/deploys", notice: 'Deploy was successfully created.' }
        format.json { render :show, status: :created, location: @deploy }
      else
        format.html { redirect_to "/deploys", notice: "Error while creating the resource" }
        format.json { render json: @deploy.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deploys/1
  # PATCH/PUT /deploys/1.json
  def update
    respond_to do |format|
      if @deploy.update(deploy_params)
        format.html { redirect_to @deploy, notice: 'Deploy was successfully updated.' }
        format.json { render :show, status: :ok, location: @deploy }
      else
        format.html { render :edit }
        format.json { render json: @deploy.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deploys/1
  # DELETE /deploys/1.json
  def destroy
    @deploy.destroy
    respond_to do |format|
      format.html { redirect_to deploys_url, notice: 'Deploy was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /deploys/getinput/1
  def getinput
    @a = []
    @workflow = @current_account.workflows.find(params[:id])
    @workflow.steps.each do |s|
      s.task.varinput.split(',').each do |v|
        @a << "#{s.name}_#{v}"
      end
    end
    render :partial => "deployinput", :locals => { :deployinputs => @a }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_deploy
      @deploy = Deploy.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def deploy_params
      params.require(:deploy).permit(:uuid, :status, :workflow_id, :deployinput => {})
    end
end
