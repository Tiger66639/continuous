class CreateCiworkers < ActiveRecord::Migration
  def change
    create_table :ciworkers do |t|
      t.string :name
      t.string :image
      t.string :flavor
      t.string :clouduuid
      t.string :status
      t.string :privateip
      t.string :uuid
      t.string :rebuild
      t.belongs_to :account
      t.belongs_to :cistack

      t.timestamps
    end
  end
end
