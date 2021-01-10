class CreateMigrations < ActiveRecord::Migration[5.2]
  def change
    change_column :device_results, :item_name, :string, limit: 48
  end
end
