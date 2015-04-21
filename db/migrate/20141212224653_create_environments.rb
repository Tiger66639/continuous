class CreateEnvironments < ActiveRecord::Migration
  def change
    create_table :environments do |t|
      t.string :name
      t.string :uuid
      t.string :status
      t.belongs_to :account


      t.timestamps
    end
  end
end
