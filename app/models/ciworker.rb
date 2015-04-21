class Ciworker < ActiveRecord::Base
  # Requirements
  require 'connector'
  require 'securerandom'
  # Model Relationships
  belongs_to :cistack
  belongs_to :account  
  # Validations
  validates :name, :image, :flavor, presence: true
  before_create :assignUuid
  after_create :createMsg
  before_destroy :deleteMsg
  # Filters
  # Attributes


  def assignUuid
    self.uuid = SecureRandom.hex(20)
    self.status = "Cloud - CI Worker requested"
  end

  def createMsg
    msg = {}
    msg[:function] = "createCiWorker"
    msg[:ciworkeruuid] = self.uuid
    msg[:name] = self.name
    msg[:flavor] = self.flavor
    msg[:image] = self.image
    msg[:cistackuuid] = Cistack.find(self.cistack_id).uuid
    logger.debug(Connector.publish('continuous-ci','provision',msg))
  end

  def deleteMsg
    msg = {}
    msg[:function] = "deleteCiWorker"
    msg[:ciworkeruuid] = self.uuid
    msg[:name] = self.name
    msg[:cistackuuid] = Cistack.find(self.cistack_id).uuid
    logger.debug(Connector.publish('continuous-ci','provision',msg))
  end

  def updateMsg
    msg = {}
    msg[:function] = "updateCiWorker"
    msg[:ciworkeruuid] = self.uuid
    msg[:name] = self.name
    logger.debug(Connector.publish('continuous-ci','provision',msg))
  end

  def sendDestroy
    deleteMsg
  end

end
