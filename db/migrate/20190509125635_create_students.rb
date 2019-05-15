class CreateStudents < ActiveRecord::Migration[5.2]
  def change
    create_table :students do |t|
      t.belongs_to :site, foreign_key: true, index: true
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :prison_number
      t.string :gender
      t.date :dob
      t.date :crd
      t.date :hdc
      t.date :rotl
      t.date :recat
      t.text :notes

      t.timestamps
    end
  end
end
