class CreateSites < ActiveRecord::Migration[5.2]
  def change
    create_table :sites do |t|
      t.string :site_name, null: false, limit: 24
    end

    add_index :sites, :site_name, unique: true
  end
end
