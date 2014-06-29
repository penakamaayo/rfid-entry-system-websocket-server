require 'sinatra/base'
require './ssclient.rb'

module RFID
  class App < Sinatra::Base
    get "/" do
      erb :"index.html"
    end

    #in  
    get "/verify/in/:rfid" do
      r=queryclient_in(params[:rfid])
      # msg="hello #{request.ip}: #{params[:rfid]}"
      # p msg
      # p "valid"
      [200,{},r]
    end

    #ou
    get "/verify/out/:rfid" do
      r=queryclient_out(params[:rfid])
      # msg="hello #{request.ip}: #{params[:rfid]}"
      # p msg
      # p "valid"
      [200,{},r]
    end


    get "/display/:rfid" do
      ssclient(params[:rfid])
      msg="hello #{request.ip}: #{params[:rfid]}"
      # p msg
    end

    get "/assets/js/application.js" do
      content_type :js
      @scheme = ENV['RACK_ENV'] == "production" ? "wss://" : "ws://"
      @host,@port = request.ip, request.port
      erb :"application.js"
    end
  end
end
