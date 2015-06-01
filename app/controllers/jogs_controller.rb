class JogsController < ApplicationController
  before_action :set_jog, only: [:show, :destroy]

  # GET /jogs
  # GET /jogs.json
  def index
    @jogs = Jog.all
  end

  # GET /jogs/1
  # GET /jogs/1.json
  def show
    @memory = @jog.results["process_mem"].map do |jog|
      [jog["time"]*1000, jog["size"]]
    end
    @retained = @jog.results["retained_objects"].map do |jog|
      [jog["time"]*1000, jog["size"]]
    end

  end

  # GET /jogs/new
  def new
    @jog = Jog.new
  end

  # POST /jogs
  # POST /jogs.json
  def create
    @jog = Jog.new(jog_params)

    respond_to do |format|
      if @jog.save
        format.html { redirect_to @jog, notice: 'Jog was successfully created.' }
        format.json { render :show, status: :created, location: @jog }
      else
        format.html { render :new }
        format.json { render json: @jog.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /jogs/1
  # DELETE /jogs/1.json
  def destroy
    @jog.destroy
    respond_to do |format|
      format.html { redirect_to jogs_url, notice: 'Jog was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_jog
      @jog = Jog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def jog_params
      params.require(:jog).permit(:n)
    end
end
