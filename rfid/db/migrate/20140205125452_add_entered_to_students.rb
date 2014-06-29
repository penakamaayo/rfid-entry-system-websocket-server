class AddEnteredToStudents < ActiveRecord::Migration
  def change
    add_column :students, :entered, :boolean
  end
end
