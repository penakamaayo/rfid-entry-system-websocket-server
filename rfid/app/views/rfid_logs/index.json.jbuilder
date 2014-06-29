json.array!(@rfid_logs) do |rfid_log|
  json.extract! rfid_log, :id, :card_rfid, :time
  json.url rfid_log_url(rfid_log, format: :json)
end
