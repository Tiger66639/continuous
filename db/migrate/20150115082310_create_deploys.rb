class CreateDeploys < ActiveRecord::Migration
  def change
    create_table :deploys do |t|
      t.string :uuid
      t.string :status
      t.string :varinput
      t.belongs_to :workflow
      t.timestamps
    end
  end
end
