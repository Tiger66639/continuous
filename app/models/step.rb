class Step < ActiveRecord::Base
  # Requirements 
  require 'connector'
  require 'securerandom'
  require 'net/https'
  # Model relationships
  belongs_to :workflow
  belongs_to :task
  belongs_to :account
  # Validations
  validates :name, presence: true
  # Filters
  # Attributes

end
