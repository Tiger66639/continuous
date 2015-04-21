class Group < ActiveRecord::Base
  # Requirements
  # Model relationships
  has_and_belongs_to_many :users
  belongs_to :account
  # Validations
  # Filters
  # Attributes
end
