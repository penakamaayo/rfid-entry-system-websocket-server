class ReportsController < ApplicationController
  def students_in
  	@students_in  = RfidLog.all
  end

  def students_out
  	@students_out = RfidLog.all
  end
end
