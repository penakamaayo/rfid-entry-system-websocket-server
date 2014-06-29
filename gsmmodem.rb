require 'rubygems'
require 'serialport'
require 'time'

#-------------------------------------------
# 20090117: tested on motorola v3i cellphone
# 20090920: read new messages
# 20110613: new copy
#           testing for nokia clone
#           not finished; more test needed
#-------------------------------------------

OK_RESULT="\r\nOK\r\n"
ERROR_RESULT="\r\nERROR\r\n"

#SELECT_TIMEOUT=10  #seconds 

class GSM
  def initialize(options = {})
    @port = SerialPort.new(options[:port] || 3, options[:baud] || 115200, options[:bits] || 8, options[:stop] || 1, SerialPort::NONE)
    @debug = options[:debug]
    # usual init
    init
    # Set to text mode
    text_mode
  end

  def GSM.open options={}
    gsm=GSM.new(options)
    yield gsm
    gsm.close
    gsm
  end

  def close
     @port.close
  end

  def cmd(cmd)
     #@port.write(cmd + "\r")
     @port.write(cmd + "\r")
     #self.wait
     wait
  end

  def init
    cmd("ATZ")
  end

  def text_mode
    cmd("AT+CMGF=1")
  end

  def delete_read_messages
    cmd("AT+CMGD= ,1")
  end

  def wait
    buffer = ''
    #while IO.select([@port], [], [], SELECT_TIMEOUT)
    while IO.select([@port], [], [])  #, SELECT_TIMEOUT)
      chr = @port.getc.chr
      #print chr if @debug == true
      p chr if @debug
      p chr.ord if @debug
      #buffer += chr
      buffer << chr
      p buffer if @debug
#      if buffer[-6..-1] == "\r\nOK\r\n"
     case
      when buffer[-6..-1] == OK_RESULT
        break
      
      #if buffer[-9..-1] == "\r\nERROR\r\n"
      when buffer[-9..-1] == ERROR_RESULT
        break
      
      # for nokia clone
      when /\+CMS ERROR\:\ \d+?\r\n/ =~ buffer
       # buffer.clear
        break
      when /\+CME ERROR\: \d+?\r\n/ =~ buffer
        break

      # for nokia clone
      when /\+CSQ\:\ \d+?\,\d+?\r\n/ =~ buffer
      #  buffer.clear
        break

      # for nokia clone
      when /AT\r0\r/ =~ buffer
      #  buffer.clear
        break


      end #case
    end #while
    
    buffer
  end

  def send_sms(options)
    cmd("AT+CMGS=\"+#{options[:number]}\"\r#{options[:message][0..139]}#{26.chr}")
  end

  def messages
     sms=cmd("AT+CMGL=\"ALL\"")
     sms.split /\+CMGL\:/
  end
  def read_new_messagesXX
    cmdstr="AT+CMGL=\"REC UNREAD\""
    sms=cmd(cmdstr) 
    sms=sms.
        sub(/^#{Regexp.escape(cmdstr)}/,"") .
        sub(/#{Regexp.escape(OK_RESULT)}$/,"") .
        strip
    # p "debug 1:"
    # p sms
    sms=sms.split("+CMGL:")
    # p "debug 2:"
    # p sms
    sms.shift
    # p "debug 3:"
    # p sms
    sms.map do |msg|
      msgid, msgstatus, *msg_num_with_text =  msg.split(",")
      # commented as as of 2013 03 18
      # old nokia text as of year 2009
      # msgsender,msgtext= 
      #   msg_num_with_text.match(/\A(\"\+\d+?\")\r\n(.*?)\Z/m).captures

      # as of 2013 03 18 using cherry mobile w globe sim:
      # sample msg_num_with_text: ["\"639067356103\"", "", "\"2013/03/18 16:39:08+32\"\r\nQQQ"]
      msgsender, _dont_care_, msg_wdatetime_wtext=msg_num_with_text
      msgdatetime, msgtext = msg_wdatetime_wtext.split("\r\n")

      msgid=msgid.to_i  #.strip.to_i
      msgsender=msgsender.gsub('"','')
      msgdatetime=msgdatetime.gsub('"','')
      msgtext=msgtext.strip

      [msgid, msgsender, msgdatetime, msgtext]
    end. sort_by{|(msgid, dummy1, dummy2, dummy3)| msgid}
  end


  def read_new_messages
    cmdstr="AT+CMGL=\"REC UNREAD\""
    sms=cmd(cmdstr) 
    sms=sms.
        sub(/^#{Regexp.escape(cmdstr)}/,"") .
        sub(/#{Regexp.escape(OK_RESULT)}$/,"") .
        strip
    sms=sms.split("+CMGL:")
    sms.shift
    sms
  end

  private :wait
end

def sample_testX
  GSM.open(:port=>'/dev/ttyACM0', :debug => false) do |gi|
    read_messages=gi.read_new_messagesXX
    
    puts "============================"
    puts "#{read_messages.size} messages received"
    puts "============================"
    cnt=0
    read_messages.each do |msgid, msgsender, msgdatetime, msgtext|
      puts "cnt     : #{cnt+=1}"
      puts "id      : #{msgid}"
      puts "sender  : #{msgsender}"
      puts "datetime: #{msgdatetime}"
      puts "text    : #{msgtext}"
      puts "--------------------"
    end
  end
end

def sample_test
  GSM.open(:port=>(ARGV[0] || '/dev/ttyACM1'), :debug => false) do |gi|
    read_messages=gi.read_new_messages
    
    puts "============================"
    puts "#{read_messages.size} messages received"
    puts "============================"
    # cnt=0
    read_messages.each.with_index do |msg,cnt|
      puts "cnt     : #{cnt+=1}"
      puts msg
      puts "--------------------"
    end
  end
end

if __FILE__ == $0
  sample_test
end
