class CreateDashboards < ActiveRecord::Migration
  def change
    create_table :dashboards do |t|
      t.string :name
      t.string :uuid
      t.string :status
      t.belongs_to :account

      t.timestamps
    end
  end
end
