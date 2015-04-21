class Script < ActiveRecord::Base
  # Requirements
  require 'connector'
  require 'securerandom'
  # Model relationships
  has_and_belongs_to_many :checks
  belongs_to :account
  # Validations
  validates :name, :content, presence: true
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
    msg[:function] = "createScript"
    msg[:id] = self.uuid
    msg[:name] = self.name
    logger.debug(Connector.publish('continuous-cv','script',msg))
  end

  def deleteMsg
    msg = {}
    msg[:function] = "deleteScript"
    msg[:id] = self.uuid
    msg[:name] = self.name
    logger.debug(Connector.publish('continuous-cv','script',msg))
  end

  def updateMsg
    msg = {}
    msg[:function] = "updateScript"
    msg[:id] = self.uuid
    msg[:name] = self.name
    logger.debug(Connector.publish('continuous-cv','script',msg))
  end

  def sendDestroy
    deleteMsg
  end

end
