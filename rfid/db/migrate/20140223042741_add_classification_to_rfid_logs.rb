class AddClassificationToRfidLogs < ActiveRecord::Migration
  def change
    add_column :rfid_logs, :classification, :string
  end
end
