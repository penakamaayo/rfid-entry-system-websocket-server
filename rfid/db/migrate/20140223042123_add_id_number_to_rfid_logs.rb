class AddIdNumberToRfidLogs < ActiveRecord::Migration
  def change
    add_column :rfid_logs, :id_number, :string
  end
end
