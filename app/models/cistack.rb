class Cistack < ActiveRecord::Base

  # Requirements
  require 'connector'
  require 'securerandom'
  require 'json'
  require 'net/https'
  # Model Relationships
  has_many :ciworkers
  has_many :projects
  has_many :replicas
  belongs_to :account
  # Validations
  validates :name, presence: true
  validates :name, uniqueness: true
  before_create :assignUuid
  after_create :createMsg
  before_destroy :deleteMsg
  # Filters
  # Attributes


  def assignUuid
    self.uuid = SecureRandom.hex(20)
    self.status = "Cloud - CI Stack requested"
  end

  def checkMonitor
    begin
      http = Net::HTTP.new(Continuous::Application.config.sensuhost, 4567)
      http.use_ssl = false
      stackfqdn = "#{self.name}.#{Continuous::Application.config.cistackdomain}"
      response = http.get("/clients/#{stackfqdn}/history")
      if response.code.to_i >= 200 and response.code.to_i < 300
        m = JSON.load response.body
        if m.size > 0
          s = true
	  logger.info("CiStack found in sensu")
          m.each do |m1|
            if m1["last_status"] != 0
              s = false
	      logger.info("There is an error on the CIStack")
            end
          end
          if s 
            self.status = "Online"
          else
            self.status = "Degraded"
          end
          self.save
        end
      end
    rescue => e
      logger.info("Error while reaching sensu to check CiStack status")
    end
  end

  def createMsg
    msg = {}
    msg[:function] = "createCiStack"
    msg[:cistackuuid] = self.uuid
    msg[:name] = self.name
    logger.debug(Connector.publish('continuous-ci','provision',msg))
  end 

  def deleteMsg
    msg = {}
    msg[:function] = "deleteCiStack"
    msg[:cistackuuid] = self.uuid
    msg[:name] = self.name
    logger.debug(Connector.publish('continuous-ci','provision',msg))
  end

  def updateMsg
    msg = {}
    msg[:function] = "updateCiStack"
    msg[:cistackuuid] = self.uuid
    msg[:name] = self.name
    logger.debug(Connector.publish('continuous-ci','provision',msg))
  end

  def addApprover(name)
    msg = {}
    msg[:function] = "addGerritApprover"
    msg[:cistackuuid] = self.uuid
    msg[:approvers] = [name]
    logger.debug(Connector.publish(self.uuid,self.uuid,msg))
  end

  def sendDestroy
    deleteMsg
    self.status = "Deleting"
    self.save
  end

end
