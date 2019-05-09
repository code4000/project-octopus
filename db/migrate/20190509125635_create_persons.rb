class CreatePersons < ActiveRecord::Migration[5.2]
  def change
    create_table :persons do |t|
      t.integer :type, null: false
      t.belongs_to :site, foreign_key: true, index: true
      t.string :name, null: false
      t.integer :gender, null: false
      t.date :dob, null: false
      t.date :crd
      t.date :hdc
      t.date :rotl
      t.date :recat
      t.text :address
      t.text :notes
      t.integer :ability_level

      t.timestamps
    end
  end
end
