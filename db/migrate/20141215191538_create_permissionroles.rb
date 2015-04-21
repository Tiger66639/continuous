class CreatePermissionroles < ActiveRecord::Migration
  def change
    create_table :permissionroles do |t|
      t.integer :grant
      t.belongs_to :permission
      t.belongs_to :role

      t.timestamps
    end
  end
end
