class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :name
      t.string :email
      t.string :uuid
      t.belongs_to :account
      t.timestamps
    end
  end
end
