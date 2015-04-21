class Account < ActiveRecord::Base

  # Requirements
  require 'securerandom'
  # Model relationships
  has_many :checks
  has_many :cistacks
  has_many :ciworkers
  has_many :dashboards
  has_many :environments
  has_many :projects
  has_many :replicas
  has_many :repositories
  has_many :scripts
  has_many :tasks
  has_many :workflows
  has_many :groups
  has_many :validation_jobs
  has_many :steps
  has_many :images
  has_and_belongs_to_many :users
  # Validations
  validates :name, :uuid, presence: true


  def setUuid
    SecureRandom.hex(20)
  end

end
