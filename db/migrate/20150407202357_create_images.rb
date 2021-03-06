class CreateImages < ActiveRecord::Migration
  def change
    create_table :images do |t|
      t.string :name
      t.string :uuid
      t.string :imagetype
      t.string :status
      t.string :location
      t.belongs_to :account
      t.timestamps
    end
  end
end
