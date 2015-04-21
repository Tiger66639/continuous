class Permissionrole < ActiveRecord::Base
  # Requirements
  # Model relationships
  belongs_to :permission
  belongs_to :role
  # Validation
  validates :role_id, :permission_id, presence: true
  # Filters
  # Attributes
end
