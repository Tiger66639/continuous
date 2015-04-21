class Role < ActiveRecord::Base

  # Requirements
  # Model Relationships
  has_and_belongs_to_many :users
  has_many :permissionroles
  has_many :permissions, through: :permissionroles
  # Validations
  # Filters
  # Attributes

end
