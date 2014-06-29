class RfidLogsController < ApplicationController
  before_action :set_rfid_log, only: [:show, :edit, :update, :destroy]

  # GET /rfid_logs
  # GET /rfid_logs.json
  def index
    # @rfid_logs = RfidLog.all
    @rfid_logs = RfidLog.search(params[:search])
  end

  # GET /rfid_logs/1
  # GET /rfid_logs/1.json
  def show
  end

  # GET /rfid_logs/new
  def new
    @rfid_log = RfidLog.new
  end

  # GET /rfid_logs/1/edit
  def edit
  end

  # POST /rfid_logs
  # POST /rfid_logs.json
  def create
    @rfid_log = RfidLog.new(rfid_log_params)

    respond_to do |format|
      if @rfid_log.save
        format.html { redirect_to @rfid_log, notice: 'Rfid log was successfully created.' }
        format.json { render action: 'show', status: :created, location: @rfid_log }
      else
        format.html { render action: 'new' }
        format.json { render json: @rfid_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rfid_logs/1
  # PATCH/PUT /rfid_logs/1.json
  def update
    respond_to do |format|
      if @rfid_log.update(rfid_log_params)
        format.html { redirect_to @rfid_log, notice: 'Rfid log was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @rfid_log.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rfid_logs/1
  # DELETE /rfid_logs/1.json
  def destroy
    @rfid_log.destroy
    respond_to do |format|
      format.html { redirect_to rfid_logs_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rfid_log
      @rfid_log = RfidLog.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def rfid_log_params
      params.require(:rfid_log).permit(:card_rfid, :time)
    end
end
