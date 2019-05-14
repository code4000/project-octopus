class AddContactNumberToSites < ActiveRecord::Migration[5.2]
  def change
    add_column :sites, :contact_number, :string
  end
end
