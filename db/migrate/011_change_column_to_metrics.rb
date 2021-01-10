class ChangeColumnToMetrics < ActiveRecord::Migration[5.2]
  def change
    change_column :metrics, :metric_name, :string, limit: 48
  end
end
