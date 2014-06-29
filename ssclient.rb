require 'faye/websocket'
require 'eventmachine'
require 'json'
require './rfid_gsmsend'

require 'active_record'

def setup_db
  ActiveRecord::Base.establish_connection(
    :adapter => "mysql2",
    :username => "root",
    :password => "silent_jman",
    :database => "rfid_development",
    :host => "localhost",
    :pool => 5,
    :timeout=> 5000
    )
end

class Student < ActiveRecord::Base
    def full_name 
        last_name.upcase + ", " + first_name.capitalize + " " + middle_name.capitalize 
    end
    def course_year
        course.upcase + " " + year_level.to_s
    end
end

class RfidLog < ActiveRecord::Base
end
setup_db 

def queryclient_out rfid
  s = Student.where(card_rfid: rfid.strip).take
  
  stud_rec = RfidLog.where(card_rfid: rfid.strip).last

  if s && stud_rec.in_out == 'in' 
    "<1>"
  else
    "<0>"
  end

  # "<#{(s ? 1 : 0)}>"
end


def queryclient_in rfid
  s = Student.where(card_rfid: rfid.strip).take
  
  stud_rec = RfidLog.where(card_rfid: rfid.strip).last

  if s && stud_rec.in_out == 'out' 
    "<1>"
  else
    "<0>"
  end

  # "<#{(s ? 1 : 0)}>"
end





def ssclient msg
  EM.run {
    # ws = Faye::WebSocket::Client.new('ws://www.example.com/')
    ws = Faye::WebSocket::Client.new('ws://localhost:3000/')
    # p "i was here!!!"
    ws.on :open do |event|
        rfid = msg.strip

        s = Student.where(card_rfid: rfid).take
        c = RfidLog.where(card_rfid: rfid).count

        classification = s.stype
        id_number = s.id_number
        full_name = s.full_name
        course_year = s.course_year
        time = Time.now

        in_out = c.odd? ? "out" : "in"

        rfid_log = RfidLog.create( 
          :card_rfid => rfid,
          :full_name => full_name,
          :classification => classification,
          :id_number => id_number,
          :time => time,
          :in_out => in_out
          )


        # in_out = c.odd? ? "in" : "out"




        in_out_time = in_out.upcase + ": " + time.asctime


        # if s.entered==true
        #     in_out_time = "Time in: " + Time.now.asctime
        # end

        # info2 = {"Time"=>Time.now.asctime,"full_name"=>full_name,"course_year"=>course_year}
        info2 = {"Time"=>in_out_time,"full_name"=>full_name,"course_year"=>course_year}
        info = s.attributes.merge(info2).to_json



        ws.send(info)



        ws.close
        ws=nil

        
        # message = full_name + "entered campus at: " + Time.to_s
        # rfid_send(s.contact_number,message)
    end

    # ws.on :message do |event|
    #   p [:message, event.data]
    # end

    # ws.on :close do |event|
    #   p [:close, event.code, event.reason]
    #   ws = nil
    # end
}
end

