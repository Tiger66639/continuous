class CreateReplicas < ActiveRecord::Migration
  def change
    create_table :replicas do |t|
      t.string :name
      t.string :destination   
      t.string :uuid
      t.string :status
      t.belongs_to :account
      t.belongs_to :cistack
      t.belongs_to :project

      t.timestamps
    end
  end
end
