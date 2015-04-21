class Check < ActiveRecord::Base
  # Requirements
  require 'connector'
  require 'securerandom'
  # Model relationships
  has_and_belongs_to_many :dashboards
  has_and_belongs_to_many :scripts
  belongs_to :account
  # Validations
  validates :name, :checktype, :information, presence: true
  validates :name, format: { with: /\A[-a-zA-Z0-9_]+\Z/, message: "Name of check only allows letters, numbers, - and _" }
  before_create :assignUuid
#  after_create :createMsg
#  before_destroy :deleteMsg
  # Filters
  # Attributes


  def assignUuid
    self.uuid = SecureRandom.hex(20)
  end

  def createMsg
    msg = {}
    msg[:function] = "createCheck"
    msg[:id] = self.uuid
    msg[:name] = self.name
    logger.debug(Connector.publish('continuous-cv','check',msg))
  end

  def deleteMsg
    msg = {}
    msg[:function] = "deleteCheck"
    msg[:id] = self.uuid
    msg[:name] = self.name
    logger.debug(Connector.publish('continuous-cv','check',msg))
  end

  def updateMsg
    msg = {}
    msg[:function] = "updateCheck"
    msg[:id] = self.uuid
    msg[:name] = self.name
    logger.debug(Connector.publish('continuous-cv','check',msg))
  end
  
  def sendDestroy
    deleteMsg
  end


end
