class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.string :uuid
      t.string :status
      t.belongs_to :account
      t.belongs_to :cistack

      t.timestamps
    end
  end
end
