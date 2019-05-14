class RemoveRegionFromSites < ActiveRecord::Migration[5.2]
  def change
    remove_column :sites, :region
  end
end
