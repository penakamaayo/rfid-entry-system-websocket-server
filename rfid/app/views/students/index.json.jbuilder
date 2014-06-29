json.array!(@students) do |student|
  json.extract! student, :id, :card_rfid, :id_number, :first_name, :middle_name, :last_name, :course, :year_level, :contact_number
  json.url student_url(student, format: :json)
end
