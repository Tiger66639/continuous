class Repository < ActiveRecord::Base
  # Requirements
  require 'connector'
  require 'securerandom'
  # Model relationships
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
    msg[:function] = "createRepository"
    msg[:id] = self.uuid
    msg[:name] = self.name
    msg[:repositorytype] = self.repotype
    logger.debug(Connector.broadcast('continuous-repo','continuous-repo',msg))
  end

  def deleteMsg
    msg = {}
    msg[:function] = "deleteRepository"
    msg[:id] = self.uuid
    msg[:name] = self.name
    msg[:repositorytype] = self.repotype
    logger.debug(Connector.broadcast('continuous-repo','continuous-repo',msg))
  end

  def updateMsg
    msg = {}
    msg[:function] = "updateRepository"
    msg[:id] = self.uuid
    msg[:name] = self.name
    logger.debug(Connector.broadcast('continuous-repo','continuous-repo',msg))
  end

  def sendDestroy
    deleteMsg
  end

end
