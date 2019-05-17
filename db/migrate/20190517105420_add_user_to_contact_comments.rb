class AddUserToContactComments < ActiveRecord::Migration[5.2]
  def change
    add_column :contact_comments, :user_id, :integer, null: false
  end
end
