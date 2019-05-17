class CreateContactComments < ActiveRecord::Migration[5.2]
  def change
    create_table :contact_comments do |t|
      t.belongs_to :contact, foreign_key: true, index: true, null: false
      t.text :body, null: false

      t.timestamps
    end
  end
end
