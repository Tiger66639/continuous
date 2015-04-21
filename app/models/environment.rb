class Environment < ActiveRecord::Base
  # Requirements
  require 'connector'
  require 'securerandom'
  # Model relationships
  has_and_belongs_to_many :workflows
  belongs_to :account
  # Validations
  validates :name, presence: true
  before_create :assignUuid
  after_create :createMsg
  before_destroy :deleteMsg
  # Filters
  # Attributes


  def assignUuid
    self.uuid = SecureRandom.hex(20)
  end

  def createMsg
    msg = {}
    msg[:function] = "createEnvironment"
    msg[:id] = self.uuid
    msg[:name] = self.name
    logger.debug(Connector.publish('continuous-cd','provision',msg))
  end

  def deleteMsg
    msg = {}
    msg[:function] = "deleteEnvironment"
    msg[:id] = self.uuid
    msg[:name] = self.name
    logger.debug(Connector.publish('continuous-cd','provision',msg))
  end

  def updateMsg
    msg = {}
    msg[:function] = "updateEnvironment"
    msg[:id] = self.uuid
    msg[:name] = self.name
    logger.debug(Connector.publish('continuous-cd','provision',msg))
  end

  def sendDestroy
    deleteMsg
  end

end
