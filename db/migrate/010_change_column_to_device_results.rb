class ChangeColumnToDeviceResults < ActiveRecord::Migration[5.2]
  def change
    change_column :device_results, :value, :string, limit: 4000
  end
end
