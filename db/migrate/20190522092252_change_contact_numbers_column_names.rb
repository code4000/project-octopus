class ChangeContactNumbersColumnNames < ActiveRecord::Migration[5.2]
  def change
    rename_column :contacts, :mobile, :mobile_number
    rename_column :contacts, :workphone, :work_number
  end
end
