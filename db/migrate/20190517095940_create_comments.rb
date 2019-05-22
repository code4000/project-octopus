class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.belongs_to :user
      t.references :resource, polymorphic: true, index: true
      t.text :body, null: false

      t.timestamps
    end
  end
end
