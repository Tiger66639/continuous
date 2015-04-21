class CreateChecks < ActiveRecord::Migration
  def change
    create_table :checks do |t|
      t.string :name
      t.string :checktype
      t.string :uuid
      t.string :status
      t.text :information
      t.belongs_to :account

      t.timestamps
    end
  end
end
