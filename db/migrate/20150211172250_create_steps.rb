class CreateSteps < ActiveRecord::Migration
  def change
    create_table :steps do |t|
      t.string :name
      t.text :onsuccess
      t.text :onfail
      t.text :oncomplete
      t.belongs_to :account
      t.belongs_to :workflow, index: true
      t.belongs_to :task, index: true

      t.timestamps
    end
  end
end
