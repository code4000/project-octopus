class AddContactNumberAndEmailToStudents < ActiveRecord::Migration[5.2]
  def change
    add_column :students, :contact_number, :string
    add_column :students, :email, :string
  end
end
