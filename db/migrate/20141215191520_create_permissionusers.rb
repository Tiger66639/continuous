class CreatePermissionusers < ActiveRecord::Migration
  def change
    create_table :permissionusers do |t|
      t.integer :grant
      t.belongs_to :permission
      t.belongs_to :user
      t.timestamps
    end
  end
end
