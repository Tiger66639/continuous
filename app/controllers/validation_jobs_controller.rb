class ValidationJobsController < ApplicationController
  before_action :set_validation_job, only: [:show, :edit, :update, :destroy]

  # GET /validation_jobs
  # GET /validation_jobs.json
  def index
    @validation_jobs = @current_account.validation_jobs.all
    @validation_job = ValidationJob.new
  end

  # GET /validation_jobs/getjob
  def getjob
    @validation_job = ValidationJob.find_by_uuid(params[:id])
    render plain: @validation_job.definition
  end

  # GET /validation_jobs/1
  # GET /validation_jobs/1.json
  def show
  end

  # GET /validation_jobs/new
  def new
    @validation_job = ValidationJob.new
  end

  # GET /validation_jobs/1/edit
  def edit
  end

  # POST /validation_jobs
  # POST /validation_jobs.json
  def create
    @validation_job = ValidationJob.new(validation_job_params)

    respond_to do |format|
      if @validation_job.save
        @current_account.validation_jobs << @validation_job
        format.html { redirect_to @validation_job, notice: 'Validation job was successfully created.' }
        format.json { render :show, status: :created, location: @validation_job }
      else
        format.html { redirect_to "/home/dashboard", notice: "Error while creating the resource" }
        format.json { render json: @validation_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /validation_jobs/1
  # PATCH/PUT /validation_jobs/1.json
  def update
    respond_to do |format|
      if @validation_job.update(validation_job_params)
        format.html { redirect_to @validation_job, notice: 'Validation job was successfully updated.' }
        format.json { render :show, status: :ok, location: @validation_job }
      else
        format.html { render :edit }
        format.json { render json: @validation_job.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /validation_jobs/1
  # DELETE /validation_jobs/1.json
  def destroy
    @validation_job.destroy
    respond_to do |format|
      format.html { redirect_to validation_jobs_url, notice: 'Validation job was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_validation_job
      @validation_job = ValidationJob.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def validation_job_params
      params.require(:validation_job).permit(:name, :description, :definition, :jobtype)
    end
end
