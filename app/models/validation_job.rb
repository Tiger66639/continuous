class ValidationJob < ActiveRecord::Base
  # Requirements
  require 'securerandom'
  require 'net/https'
  # Model relationships
  belongs_to :account
  # Validations
  validates :name, :jobtype, :description, :definition, presence: true
  validates :name, uniqueness: true
  before_create :assignUuid
  before_create :saveJobInMesos
  before_destroy :deleteJobInMesos
  before_update :updateJobInMesos
  # Filters
  # Attributes
 

  def assignUuid
    self.uuid = SecureRandom.hex(20)
  end
 
  def saveJobInMesos
    begin
      http = Net::HTTP.new(Continuous::Application.config.mesoshost, 5051)
      http.use_ssl = false
      data = {}
      data["cmd"] = "sleep 10 ; wget http://#{Continuous::Application.config.continuousfqdn}/validation_jobs/getjob/#{self.uuid} ; dos2unix #{self.uuid} ; sh ./#{self.uuid} ; echo done ;"
      data["cpus"] = 0.5
      data["id"] = "#{self.name}-#{self.uuid}"
      data["instances"] = 1
      data["mem"] = 512
      data["container"] = {}
      data["container"]["type"] = "DOCKER"
      data["container"]["docker"] = {}
      data["container"]["docker"]["image"] = "#{Continuous::Application.config.dockerregistry}:8080/centos-latest"
      data["uris"] = ["http://#{Continuous::Application.config.continuousfqdn}/validation_jobs/getjob/#{self.uuid}"]
      data["env"] = {}
      data["env"]["HOME"] = "/root/"
      response = http.post("/v2/apps/", data.to_json, {'content-type'=>'application/json'})
      if response.code.to_i >= 200 and response.code.to_i < 300
        logger.info(response.body.to_s)
        true
      else
        logger.info(response.body.to_s)
        false
      end
    rescue => e
      logger.info("Error while submitting job to mesos #{e.inspect.to_s}")
      false
    end
  end

  def updateJobInMesos
    begin
      http = Net::HTTP.new(Continuous::Application.config.mesoshost, 5051)
      http.use_ssl = false
      data = {}
      data["cmd"] = "sleep 10 ; wget http://#{Continuous::Application.config.continuousfqdn}/validation_jobs/getjob/#{self.uuid} ; dos2unix #{self.uuid} ; sh ./#{self.uuid} ; echo done ;"
      data["cpus"] = 0.5
      data["id"] = "#{self.name}-#{self.uuid}"
      data["instances"] = 1
      data["mem"] = 512
      data["container"] = {}
      data["container"]["type"] = "DOCKER"
      data["container"]["docker"] = {}
      data["container"]["image"] = "#{Continuous::Application.config.dockerregistry}:8080/centos-latest"
      data["uris"] = ["http://#{Continuous::Application.config.continuousfqdn}/validation_jobs/getjob/#{self.uuid}"]
      data["env"] = {}
      data["env"]["HOME"] = "/root/"
      response = http.put("/v2/apps/#{self.name}-#{self.uuid}", data.to_json, {'content-type'=>'application/json'})
      if response.code.to_i >= 200 and response.code.to_i < 300
        debug.info(response.body.to_s)
        true
      else
        debug.info(response.body.to_s)
        false
      end
    rescue => e
      logger.info("Error while submitting job to mesos #{e.inspect.to_s}")
      false
    end
  end


  def deleteJobInMesos
    begin
      http = Net::HTTP.new(Continuous::Application.config.mesoshost, 5051)
      http.use_ssl = false
      response = http.delete("/v2/apps/#{self.name}-#{self.uuid}",{'Content-type' => 'application/json'})
      if response.code.to_i >= 200 and response.code.to_i < 300 
        true
      else
        false
      end
    rescue => e
      logger.info("Error while submitting job to mesos #{e.inspect.to_s}")
      false
    end
  end
end
