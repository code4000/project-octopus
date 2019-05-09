class CreateSites < ActiveRecord::Migration[5.2]
  def change
    create_table :sites do |t|
      t.string :name, null: false
      t.integer :capacity
      t.text :address
      t.string :manager
      t.text :notes

      t.timestamps
    end
  end
end
