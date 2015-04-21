class Permissionuser < ActiveRecord::Base
  # Requirements
  # Model Relationships
  belongs_to :user
  belongs_to :permission
  # Validations
  validates :permission_id, :user_id, presence: true
  # Filters
end
