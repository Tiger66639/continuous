class Image < ActiveRecord::Base
  # Requirements
  require 'net/https'
  require 'securerandom'
  require 'json'
  require 'base64'
  # Model Relationships
  belongs_to :account
  # Validations
  validates :name, :imagetype, :description, :location, presence: true
  before_create :saveImageService
  before_destroy :destroyImageService
  # Filters
  # Attributes
    

  def queryImageService
    begin
      http = Net::HTTP.new(Continuous::Application.config.registryhost, 8080)
      http.use_ssl = true
      pass = Base64.encode64("#{Continuous::Application.config.registryuser}:#{Continuous::Application.config.registrypassword}")
      webpass = "Basic #{pass}"
      header = {'Authorization' => webpass, 'Authentication' => webpass, 'Content-type' => 'application/json' }
      response = http.get("/v1/_ping", header)
      if response.code.to_i == 200
        return true
      else
        return false
      end
    rescue
      logger.info("Error while querying the docker registry service")
      return false
    end
  end

  def saveImageService
    if queryImageService
    else
      return false
    end
  end

  def destroyImageService
    if queryImageService
    else
      return false
    end
  end

end
