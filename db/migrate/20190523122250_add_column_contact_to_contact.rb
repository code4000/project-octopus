class AddColumnContactToContact < ActiveRecord::Migration[5.2]
  def change
    add_column :contacts, :contact, :string
  end
end
