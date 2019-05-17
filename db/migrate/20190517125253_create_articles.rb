class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.belongs_to :user, foreign_key: true, index: true
      t.string :title, null: false
      t.text :content, null: false
      t.boolean :publish, default: false
      t.date :published_at, default: -> { 'CURRENT_TIMESTAMP' }

      t.timestamps
    end
  end
end