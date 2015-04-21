class Replica < ActiveRecord::Base
  # Requirements
  require 'connector'
  require 'securerandom'
  # Model relationships
  belongs_to :cistack
  belongs_to :project
  belongs_to :account
  # Validations
  validates :name, :destination, presence: true
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
    msg[:function] = "createGerritReplica"
    msg[:replicauuid] = self.uuid
    msg[:name] = self.name
    msg[:projectuuid] = Project.find_by_id(self.project_id).uuid
    logger.debug(Connector.publish('continuous-ci','replica',msg))
  end

  def deleteMsg
    msg = {}
    msg[:function] = "deleteGerritReplica"
    msg[:replicauuid] = self.uuid
    msg[:name] = self.name
    msg[:projectuuid] = Project.find_by_id(self.project_id).uuid
    logger.debug(Connector.publish('continuous-ci','replica',msg))
  end

  def updateMsg
    msg = {}
    msg[:function] = "updateGerritReplica"
    msg[:replicauuid] = self.uuid
    msg[:name] = self.name
    msg[:projectuuid] = Project.find_by_id(self.project_id).uuid
    logger.debug(Connector.publish('continuous-ci','replica',msg))
  end

  def sendDestroy
    deleteMsg
  end
end

