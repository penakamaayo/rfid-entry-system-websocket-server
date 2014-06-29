class CreateRfidLogs < ActiveRecord::Migration
  def change
    create_table :rfid_logs do |t|
      t.string :card_rfid
      t.datetime :time

      t.timestamps
    end
  end
end
