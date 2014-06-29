class AddFullNameToRfidLogs < ActiveRecord::Migration
  def change
    add_column :rfid_logs, :full_name, :string
  end
end
