class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :card_rfid
      t.string :id_number
      t.string :first_name
      t.string :middle_name
      t.string :last_name
      t.string :course
      t.integer :year_level
      t.string :contact_number

      t.timestamps
    end
  end
end
