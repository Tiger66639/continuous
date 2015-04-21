class CreateScripts < ActiveRecord::Migration
  def change
    create_table :scripts do |t|
      t.string :name
      t.text :content
      t.string :uuid
      t.string :status
      t.belongs_to :account

      t.timestamps
    end
  end
end
