class ChecksScripts < ActiveRecord::Migration
  def change
    create_table :checks_scripts do |t|
      t.belongs_to :check
      t.belongs_to :script
    end
  end
end
