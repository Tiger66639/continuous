class Permission < ActiveRecord::Base

  # Requirements
  # Model relationships
  has_many :permissionusers 
  has_many :users, through: :permissionusers
  has_many :permissionroles
  has_many :roles, through: :permissionroles
  # Validations
  validates :name, :key, :module, presence: true
  validates :key, uniqueness: true
  # Filters
  # Attributes

end
