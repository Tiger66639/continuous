class CreateWorkflows < ActiveRecord::Migration
  def change
    create_table :workflows do |t|
      t.string :name
      t.string :uuid
      t.string :status
      t.string :workflowtype
      t.string :varinput
      t.text :description
      t.text :definition
      t.belongs_to :account

      t.timestamps
    end
  end
end
