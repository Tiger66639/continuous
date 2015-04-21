class CiworkersController < ApplicationController
  before_action :set_ciworker, only: [:show, :edit, :update, :destroy]
  before_action :checkOwner, only: [:show, :edit, :update, :destroy]
  # GET /ciworkers
  # GET /ciworkers.json
  def index
    @ciworkers = @current_account.ciworkers.all
    @ciworker = Ciworker.new
    @cistacks = @current_account.cistacks
  end

  # GET /ciworkers/1
  # GET /ciworkers/1.json
  def show
  end

  # GET /ciworkers/new
  def new
    @ciworker = Ciworker.new
    @cistacks = @current_account.cistacks
  end

  # GET /ciworkers/1/edit
  def edit
    @cistacks = @current_account.cistacks
  end

  # POST /ciworkers
  # POST /ciworkers.json
  def create
    @ciworker = Ciworker.new(ciworker_params)

    respond_to do |format|
      if @ciworker.save
        @current_account.ciworkers << @ciworker
        format.html { redirect_to "/ciworkers", notice: 'Ciworker was successfully created.' }
        format.json { render :show, status: :created, location: @ciworker }
      else
        format.html { redirect_to "/deploys", notice: "Error while creating the resource" }
        format.json { render json: @ciworker.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /ciworkers/1
  # PATCH/PUT /ciworkers/1.json
  def update
    respond_to do |format|
      if @ciworker.update(ciworker_params)
        format.html { redirect_to @ciworker, notice: 'Ciworker was successfully updated.' }
        format.json { render :show, status: :ok, location: @ciworker }
      else
        format.html { render :edit }
        format.json { render json: @ciworker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /ciworkers/1
  # DELETE /ciworkers/1.json
  def destroy
    @ciworker.sendDestroy
    #@ciworker.destroy
    respond_to do |format|
      format.html { redirect_to ciworkers_url, notice: 'Ciworker was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def tablelist
    @ciworkers = @current_account.ciworkers.all
    render :partial => "tablelist", :locals => { :ciworkers => @ciworkers }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ciworker
      @ciworker = Ciworker.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def ciworker_params
      params.require(:ciworker).permit(:name, :image, :flavor, :cistack_id)
    end

    def checkOwner
      checkObjectOwner("ciworkers", @ciworker)
    end
end
