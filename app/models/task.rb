class Task < ActiveRecord::Base
  # Requirements 
  require 'connector'
  require 'securerandom'
  require 'net/https'
  # Model relationships
  has_many :steps
  has_many :workflows, :through => :steps
  belongs_to :account
  has_many :deploys
  # Validations
  validates :name, :tasktype, :description, presence: true
  validates :http_url, presence: true if :tasktype == "http"
  validates :smtp_to, :smtp_subject, :smtp_body, :smtp_server, :smtp_password, presence: true if :tasktype == "smtp"
  validates :ssh_cmd, :ssh_host, presence: true if :tasktype == "ssh"
  validate :varinput_no_numbers
  before_create :saveTaskInMistral
  before_destroy :deleteTaskInMistral
  # Filters
  # Attributes

  attr_accessor :http_url
  attr_accessor :http_method
  attr_accessor :http_params
  attr_accessor :http_body
  attr_accessor :http_headers
  attr_accessor :http_cookies
  attr_accessor :http_auth
  attr_accessor :http_timeout
  attr_accessor :http_allow_redirects
  attr_accessor :http_proxies
  attr_accessor :smtp_to
  attr_accessor :smtp_subject
  attr_accessor :smtp_body
  attr_accessor :smtp_from
  attr_accessor :smtp_server
  attr_accessor :smtp_password
  attr_accessor :ssh_cmd
  attr_accessor :ssh_host
  attr_accessor :ssh_username
  attr_accessor :ssh_password

  HTTPTEMPLATE = "
---
version: '2.0'
<%= self.name %>:
  <% if self.varinput != '' %>
  input:
    <% self.varinput.split(',').each do |i| %>
    - <%= i %>
    <% end %>
  <% end %>
  base: std.http
  base-input:
    url: <%= self.http_url %>
    <% if self.http_method %>
    method: <%= self.http_method %>
    <% end %>
    <% if self.http_params %>
    params: <%= self.http_params %>
    <% end %>
    <% if self.http_body %>
    body: <%= self.http_body %>
    <% end %>
    <% if self.http_headers %>
    headers: <%= self.http_headers %>
    <% end %>
    <% if self.http_cookies %>
    cookies: <%= self.http_cookies %>
    <% end %>
    <% if self.http_auth %>
    auth: <%= self.http_auth %>
    <% end %>
    <% if self.http_timeout %>
    timeout: <%= self.http_timeout %>
    <% end %>
    <% if self.http_allow_redirects %>
    allow_redirects: <%= self.http_allow_redirects %>
    <% end %>
    <% if self.http_proxies %>
    proxies: <%= self.http_proxies %>
    <% end %>
"

  SSHTEMPLATE = "
---
version: '2.0'

<%= self.name %>:
  <% if self.varinput != '' %>
  input:
    <% self.varinput.split(',').each do |i| %>
    - <%= i %>
    <% end %>
  <% end %>
  base: std.ssh
  base-input:
    cmd: <%= self.ssh_cmd %>
    host: <%= self.ssh_host %>
    <% if self.ssh_username != '' %>
    username: <%= self.ssh_username %>
    <% end %>
    <% if self.ssh_password != '' %>
    password: <%= self.ssh_password %>
    <% end %>
"

  SMTPTEMPLATE = "
---
version: '2.0'

<%= self.name %>:
  <% if self.varinput != '' %>
  input:
    <% self.varinput.split(',').each do |i| %>
    - <%= i %>
    <% end %>
  <% end %>
  base: std.smtp
  base-input:
    to_addrs: <%= self.smtp_to %>
    subject: <%= self.smtp_subject %>
    body: |
      <%= self.smtp_body %>
    from_addr: <%= self.smtp_from %>
    smtp_server: <%= self.smtp_server %>
    smtp_password: <%= self.smtp_password %>
"

  def saveTaskInMistral
   if self.tasktype == "http"
     t = ERB.new(HTTPTEMPLATE)
     result = t.result(binding)
   elsif self.tasktype == "smtp"
     t = ERB.new(SMTPTEMPLATE)
     result = t.result(binding)
   elsif self.tasktype == "ssh"
     t = ERB.new(SSHTEMPLATE)
     result = t.result(binding)
   else
     result = false
   end
   logger.info(result)
   if result
     begin
       http = Net::HTTP.new(Continuous::Application.config.mistralhost,8989)
       http.use_ssl = false
       response = http.post("/v2/actions/", result, {'content-type'=>'text/plain'})
       if response.code.to_i >= 200 and response.code.to_i < 300
         true
       else
         logger.info("Error while posting new task")
         logger.info(response.body)
         false
       end
     rescue => e
       logger.info("Error in mistral #{e.inspect}")
       return false
     end
   else
     false
   end
  end

  def deleteTaskInMistral
    http = Net::HTTP.new(Continuous::Application.config.mistralhost,8989)
    http.use_ssl = false
    response = http.delete("/v2/actions/#{self.name}",{'content-type'=>'application/json'}) 
    if response.code.to_i >= 200 and response.code.to_i < 300
      true
    else
      false
    end
  end


  def createMsg
    msg = {}
    msg[:function] = "createTask"
    msg[:taskuuid] = self.uuid
    msg[:name] = self.name
    logger.debug(Connector.publish('continuous-cd','task',msg))
  end

  def deleteMsg
    msg = {}
    msg[:function] = "deleteTask"
    msg[:taskuuid] = self.uuid
    msg[:name] = self.name
    logger.debug(Connector.publish('continuous-cd','task',msg))
  end

  def updateMsg
    msg = {}
    msg[:function] = "updateTask"
    msg[:taskuuid] = self.uuid
    msg[:name] = self.name
    logger.debug(Connector.publish('continuous-cd','task',msg))
  end

  def sendDestroy
    deleteMsg
  end

  def varinput_no_numbers
    if self.varinput != ''
      self.varinput.split(',').each do |v|
        if v =~ /[0-9].*/
          errors.add(:varinput, "can't have number")
        end
      end
    end
  end

end
