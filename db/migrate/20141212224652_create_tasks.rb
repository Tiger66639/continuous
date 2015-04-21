class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
      t.string :name
      t.string :tasktype
      t.string :uuid
      t.string :status
      t.string :varinput
      t.text :description
      t.text :definition
      t.belongs_to :account

      t.timestamps
    end
  end
end
