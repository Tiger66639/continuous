class Dashboard < ActiveRecord::Base
  # Requirements
  require 'connector'
  require 'securerandom'
  # Model Relationships
  has_and_belongs_to_many :checks
  belongs_to :account  
  # Validations
  validates :name, presence: true
  validates :name, format: { with: /\A[-a-zA-Z0-9_]+\Z/, message: "Name of check only allows letters, numbers, - and _" }
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
    msg[:function] = "createDashboard"
    msg[:id] = self.uuid
    msg[:name] = self.name
    msg[:checks] = []
    self.checks.each do |c|
      msg[:checks] << {:name => c.name, :checktype => c.checktype, :info => c.information}
    end
    logger.info(msg.to_s)
    logger.debug(Connector.broadcast('continuous-cv','continuous-cv',msg))
  end

  def deleteMsg
    msg = {}
    msg[:function] = "deleteDashboard"
    msg[:id] = self.uuid
    msg[:name] = self.name
    logger.debug(Connector.broadcast('continuous-cv','continuous-cv',msg))
  end

  def updateMsg
    msg = {}
    msg[:function] = "updateDashboard"
    msg[:id] = self.uuid
    msg[:name] = self.name
    logger.debug(Connector.broadcast('continuous-cv','continuous-cv',msg))
  end

  def sendDestroy
    deleteMsg
  end

end
