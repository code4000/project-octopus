class AddGenderToSites < ActiveRecord::Migration[5.2]
  def change
    add_column :sites, :gender, :string
  end
end
