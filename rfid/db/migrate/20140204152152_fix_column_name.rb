class FixColumnName < ActiveRecord::Migration
  def change
  	rename_column :students, :type, :stype
  end
end
