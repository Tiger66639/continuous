class EnvironmentsWorkflows < ActiveRecord::Migration
  def change
    create_table :environments_workflows do |t|
      t.belongs_to :environment
      t.belongs_to :workflow
    end
  end
end
