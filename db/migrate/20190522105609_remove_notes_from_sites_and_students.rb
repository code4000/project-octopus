class RemoveNotesFromSitesAndStudents < ActiveRecord::Migration[5.2]
  def change
    remove_column :sites, :notes
    remove_column :students, :notes
  end
end
