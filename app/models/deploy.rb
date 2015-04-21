class Deploy < ActiveRecord::Base

  require 'net/https'
  require 'json'

  belongs_to :workflow
  before_create :executeWorkflowInMistral

  attr_accessor :deployinput

  def executeWorkflowInMistral
    if deployinput
      w = {"workflow_name"=>Workflow.find(self.workflow_id).name, "input" => "#{deployinput.to_json}" }
      logger.info("Deploying with input")
    else
      w = {"workflow_name"=>Workflow.find(self.workflow_id).name}
      logger.info("Deploying WITHOUT input")
    end
    logger.info(w.to_s)
    logger.info(w.to_json.to_s)
    http = Net::HTTP.new(Continuous::Application.config.mistralhost,8989)
    http.use_ssl = false
    response = http.post("/v2/executions",w.to_json,{'content-type'=>'application/json'})
    if response.code.to_i >= 200 and response.code.to_i < 300
      self.uuid = JSON.load(response.body)["id"]
      self.status = JSON.load(response.body)["state"]
      true
    else
      logger.info(response.code.to_s)
      logger.info(response.body.to_s)
      false
    end
  end

  def getWorkflowInMistral
    http = Net::HTTP.new(Continuous::Application.config.mistralhost,8989)
    http.use_ssl = false
    response = http.get("/v2/executions/#{self.uuid}",{'content-type'=>'application/json'})
    if response.code.to_i >= 200 and response.code.to_i < 300
      self.status = JSON.load(response.body)["state"]
      true
    else
      false
    end
  end

  def getTasksInMistral
    listTasks = []
    http = Net::HTTP.new(Continuous::Application.config.mistralhost,8989)
    http.use_ssl = false
    response = http.get("/v2/tasks",{'content-type'=>'application/json'})
    if response.code.to_i >= 200 and response.code.to_i < 300
      JSON.load(response.body)["tasks"].each do |t|
        if t["execution_id"] == self.uuid 
          listTasks << {"task" => t["name"], "status" => t["state"], "updated_at" => t["updated_at"]}
        end
      end
      listTasks
    else
      listTasks = []
    end
  end

end
