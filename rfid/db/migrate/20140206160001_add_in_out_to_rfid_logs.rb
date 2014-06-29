class AddInOutToRfidLogs < ActiveRecord::Migration
  def change
    add_column :rfid_logs, :in_out, :string
  end
end
