class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :uuid
      t.string :name
      t.belongs_to :account
      t.timestamps
    end
  end
end
