class ChecksDashboards < ActiveRecord::Migration
  def change
    create_table :checks_dashboards do |t|
      t.belongs_to :check
      t.belongs_to :dashboard
    end
  end
end
