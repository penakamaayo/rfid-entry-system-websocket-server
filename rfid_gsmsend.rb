require 'rubygems'
require 'serialport'
require 'time'
require './gsmmodem'

def rfid_send(phone_number,message)
  GSM.open(:port=>'/dev/ttyUSB0', :debug => false) do |gi|
    gi.send_sms(
      :number => phone_number, 
      :message => message 
      )
    p "sending txt." + phone_number
  end
end

