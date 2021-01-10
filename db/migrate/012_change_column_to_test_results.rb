class ChangeColumnToTestResults < ActiveRecord::Migration[5.2]
  def change
    change_column :test_results, :value, :string, limit: 4000
  end
end
