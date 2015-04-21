class Project < ActiveRecord::Base
  # Requirements
  require 'connector'
  require 'securerandom'
  # Model relationships
  belongs_to :cistack
  has_many :replicas
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
    msg[:function] = "createGerritProject"
    msg[:projectuuid] = self.uuid
    msg[:name] = self.name
    msg[:cistackuuid] = Cistack.find(self.cistack_id).uuid
    logger.debug(Connector.publish('continuous-ci','project',msg))
  end

  def deleteMsg
    msg = {}
    msg[:function] = "deleteGerritProject"
    msg[:projectuuid] = self.uuid
    msg[:name] = self.name
    msg[:cistackuuid] = Cistack.find(self.cistack_id).uuid
    logger.debug(Connector.publish('continuous-ci','project',msg))
  end

  def updateMsg
    msg = {}
    msg[:function] = "updateGerritProject"
    msg[:projectuuid] = self.uuid
    msg[:name] = self.name
    msg[:cistackuuid] = Cistack.find(self.cistack_id).uuid
    logger.debug(Connector.publish('continuous-ci','project',msg))
  end

  def sendDestroy
    deleteMsg
  end

end
