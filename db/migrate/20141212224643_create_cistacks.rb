class CreateCistacks < ActiveRecord::Migration
  def change
    create_table :cistacks do |t|
      t.string :name
      t.string :uuid
      t.string :clouduuid
      t.string :status
      t.string :publicip
      t.string :privateip
      t.belongs_to :account
      t.timestamps
    end
  end
end
