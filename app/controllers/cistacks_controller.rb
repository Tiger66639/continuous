class CistacksController < ApplicationController
  before_action :set_cistack, only: [:show, :edit, :update, :destroy]
  before_action :checkOwner, only: [:show, :edit, :update, :destroy]
  # GET /cistacks
  # GET /cistacks.json
  def index
    @cistacks = @current_account.cistacks.all
    @cistacks.each do |c|
      c.checkMonitor
    end
    @cistack = Cistack.new
  end

  # GET /cistacks/1
  # GET /cistacks/1.json
  def show
  end

  # GET /cistacks/new
  def new
    @cistack = Cistack.new
  end

  # GET /cistacks/1/edit
  def edit
  end

  # POST /cistacks
  # POST /cistacks.json
  def create
    @cistack = Cistack.new(cistack_params)

    respond_to do |format|
      if @cistack.save
        @current_account.cistacks << @cistack
        format.html { redirect_to "/cistacks", notice: 'Cistack was successfully created.' }
        format.json { render :show, status: :created, location: @cistack }
      else
        format.html { redirect_to "/deploys", notice: "Error while creating the resource" }
        format.json { render json: @cistack.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cistacks/1
  # PATCH/PUT /cistacks/1.json
  def update
    respond_to do |format|
      if @cistack.update(cistack_params)
        format.html { redirect_to @cistack, notice: 'Cistack was successfully updated.' }
        format.json { render :show, status: :ok, location: @cistack }
      else
        format.html { render :edit }
        format.json { render json: @cistack.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cistacks/1
  # DELETE /cistacks/1.json
  def destroy
    @cistack.sendDestroy
    #@cistack.destroy
    respond_to do |format|
      format.html { redirect_to cistacks_url, notice: 'Cistack was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def tablelist
    @cistacks = @current_account.cistacks.all
    @cistacks.each do |c|
      c.checkMonitor
    end
    render :partial => "tablelist", :locals => { :cistacks => @cistacks }
  end

  def manage
    if request.post?
      cistack = @current_account.cistacks.find(params[:id])
      user = User.find(params[:userid])
      cistack.addApprover(user.name)
      redirect_to cistacks_url
    elsif request.get?
      @users = User.all
      @cistack = Cistack.find(params[:id])
    else
      redirect_to cistacks_url
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cistack
      @cistack = Cistack.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cistack_params
      params.require(:cistack).permit(:name)
    end

    def checkOwner
      checkObjectOwner("cistacks", @cistack)
    end

end
