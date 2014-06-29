require 'faye'
require './app'
require './middlewares/rfid_backend'

# use Faye::RackAdapter, :mount      => '/faye',
#                        :timeout    => 25  #,
#                        # :extensions => [Something.new]
Faye::WebSocket.load_adapter('thin')
use RFID::RFIDBackend


require File.expand_path('../app', __FILE__)



# run Sinatra::Application
run RFID::App
