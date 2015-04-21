class Workflow < ActiveRecord::Base
  # Requirements
  require 'connector'
  require 'securerandom'
  require 'net/https'
  # Modal relationships
  has_many :steps
  has_many :tasks, :through => :steps
  has_and_belongs_to_many :environments
  belongs_to :account
  has_many :deploys
  # Validations
  validates :name, :description, presence: true
  validates :name, uniqueness: true
  
  # TODO Fix this to use the backend
  #before_create :assignUuid
  #after_create :createMsg
  #before_destroy :deleteMsg
 
  before_create :saveVarInput
  before_create :saveWorkflowInMistral
  before_destroy :deleteWorkflowInMistral
  before_update :saveVarInput
  before_update :updateWorkflowInMistral
  # Filters
  # Attributes


  WORKFLOWTEMPLATE = "
---
version: '2.0'

<%= self.name %>:
  description: <%= self.description %>
  type: direct
  <% if self.steps.size > 0 %>
  <% hasinput = false
     self.steps.each {|s| hasinput = true if s.task.varinput != '' } %>
  <% if hasinput %>
  input:
    <% self.steps.each do |s| %>
      <% s.task.varinput.split(',').each do |v| %>
    - <%= s.name %>_<%= v %>
      <% end %>
    <% end %>
  <% end %>
  <% end %>
  task-defaults:
    policies:
      wait-before: 2
      wait-after: 2
  tasks:
    continuous_workflow:
      action: std.echo
      input:
        output: 'Workflow started by Continuous'
      <% if self.steps.size > 0 %>
      on-success:
        - <%= self.steps.first.name %>
      <% end %>
  <% self.steps.each do |s| %>
    <%= s.name %>:
      action: <%= s.task.name %>
      <% if s.task.varinput != '' %>
      <% s.task.varinput.split(',').each do |v| %>
        <%= v %>: $.<%= s.name %>_<%= v %>
      <% end %>
      <% end %>
      <% if not s.onsuccess.nil? %>
      on-success:
      <% s.onsuccess.split('\n').each do |so| %>
        - <%= so %>
      <% end %>
      <% end %>
      <% if not s.oncomplete.nil? %>
      on-complete:
      <% s.oncomplete.split('\n').each do |so| %>
        - <%= so %>
      <% end %>
      <% end %>
      <% if not s.onfail.nil? %>
      on-error:
      <% s.onfail.split('\n').each do |so| %>
        - <%= so %>
      <% end %>
      <% end %>
  <% end %>
"

  def saveVarInput
  w = ERB.new(WORKFLOWTEMPLATE)
  result = w.result(binding)
  logger.info(result)
  #  varinput = ""
  #  self.tasks.each do |t|
  #    t.varinput.split(',') do |v|
  #      varinput += v + ','
  #    end
  #  end
  #  self.varinput = varinput.chomp(',')
  end

  def saveWorkflowInMistral
    w = ERB.new(WORKFLOWTEMPLATE)
    result = w.result(binding)
    logger.info(result)
    http = Net::HTTP.new(Continuous::Application.config.mistralhost,8989)
    http.use_ssl = false
    response = http.post("/v2/workflows", result,{'content-type'=>'text/plain'})
    if response.code.to_i >= 200 and response.code.to_i <= 300
      logger.info(response.body)
      self.uuid = JSON.load(response.body)["workflows"][0]["id"]
      true
    else
      logger.info(response.body)
      false
    end
  end

  def updateWorkflowInMistral
    w = ERB.new(WORKFLOWTEMPLATE)
    result = w.result(binding)
    logger.info(result)
    http = Net::HTTP.new(Continuous::Application.config.mistralhost,8989)
    http.use_ssl = false
    response = http.put("/v2/workflows", result,{'content-type'=>'text/plain'})
    if response.code.to_i >= 200 and response.code.to_i <= 300
      self.uuid = JSON.load(response.body)["workflows"][0]["id"]
      true
    else
      false
    end
  end

  def deleteWorkflowInMistral
    http = Net::HTTP.new(Continuous::Application.config.mistralhost, 8989)
    http.use_ssl = false
    response = http.delete("/v2/workflows/#{self.name}",{'content-type'=>'application/json'})
    if response.code.to_i >= 200 and response.code.to_i < 300
      true
    else
      false
    end
  end

  def assignUuid
    self.uuid = SecureRandom.hex(20)
  end

  def createMsg
    msg = {}
    msg[:function] = "createWorkflow"
    msg[:workflowuuid] = self.uuid
    msg[:name] = self.name
    logger.debug(Connector.publish('continuous-cd','workflow',msg))
  end

  def deleteMsg
    msg = {}
    msg[:function] = "deleteWorkflow"
    msg[:workflowuuid] = self.uuid
    msg[:name] = self.name
    logger.debug(Connector.publish('continuous-cd','workflow',msg))
  end

  def updateMsg
    msg = {}
    msg[:function] = "updateWorkflow"
    msg[:workflowuuid] = self.uuid
    msg[:name] = self.name
    logger.debug(Connector.publish('continuous-cd','workflow',msg))
  end

  def sendDestroy
    deleteMsg
  end

end
