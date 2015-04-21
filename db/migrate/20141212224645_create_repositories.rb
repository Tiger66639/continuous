class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :name
      t.string :uuid
      t.string :repotype
      t.string :status
      t.belongs_to :account

      t.timestamps
    end
  end
end
