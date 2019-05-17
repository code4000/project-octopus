class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :role
      t.string :organisation
      t.string :mobile_number
      t.string :work_number
      t.string :email, null: false
      t.text :about

      t.timestamps
    end
  end
end
