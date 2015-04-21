class CreateValidationJobs < ActiveRecord::Migration
  def change
    create_table :validation_jobs do |t|
      t.string :name
      t.string :jobtype
      t.string :uuid
      t.string :status
      t.string :description
      t.text :definition
      t.belongs_to :account

      t.timestamps
    end
  end
end
