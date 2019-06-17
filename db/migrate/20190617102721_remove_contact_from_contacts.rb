class RemoveContactFromContacts < ActiveRecord::Migration[5.2]
  def change
    remove_column :contacts, :contact, :string
  end
end
