# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  removestep = (clicked) ->
    $.ajax
      url: '/workflows/deltask/'
      type: 'DELETE'
      data:
        id: clicked.data("workflow_id")
        step: clicked.data("step_id")
      success: (data) -> $("div#workflowtasks").html(data)
  false

  addtask = (task, workflow, stepname) ->
    $.post '/workflows/addtask/',
      id: workflow
      task: task
      stepname: stepname
      (data) -> $('div#workflowtasks').html(data)
  false

  $('select#workflow_task_id').change ->
    task = $('select#workflow_task_id option:selected').val()
    workflow = $('input#workflow_id').val()
    stepname = $('input#step_name').val()
    if task isnt "" and stepname isnt ""
      addtask(task, workflow, stepname)
  false

  add_on_completed = (workflow, step, stepid) ->
    $.post '/workflows/step/completed',
      id: workflow
      step: step
      stepid: stepid
      (data) -> $('div#workflowtasks').html(data)
  false

  add_on_success   = (workflow, step, stepid) ->
    $.post '/workflows/step/success',
      id: workflow
      step: step
      stepid: stepid
      (data) -> $('div#workflowtasks').html(data)
  false  

  add_on_failure   = (workflow, step, stepid) ->
    $.post '/workflows/step/failure',
      id: workflow
      step: step
      stepid: stepid
      (data) -> $('div#workflowtasks').html(data)
  false

  remove_on_completed = (clicked) ->
    workflow = $('input#workflow_id').val()
    step = clicked.data("on-step")
    stepid = clicked.data("id-step")
    line = clicked.data("line-step")
    $.ajax
      url: '/workflows/step/completed'
      type: 'DELETE'
      data:
        id: workflow
        step: step
        stepid: stepid
        stepline: line
      success: (data) -> $('div#workflowtasks').html(data)
  false

  remove_on_success   = (clicked) ->
    workflow = $('input#workflow_id').val()
    step = clicked.data("on-step")
    stepid = clicked.data("id-step")
    line = clicked.data("line-step")
    $.ajax
      url: '/workflows/step/success'
      type: 'DELETE'
      data:
        id: workflow
        step: step
        stepid: stepid
        stepline: line
      success: (data) -> $('div#workflowtasks').html(data)
  false
 
  remove_on_failure   = (clicked) ->
    workflow = $('input#workflow_id').val()
    step = clicked.data("on-step")
    stepid = clicked.data("id-step")
    line = clicked.data("line-step")
    $.ajax
      url: '/workflows/step/failure'
      type: 'DELETE'
      data:
        id: workflow
        step: step
        stepid: stepid
        stepline: line
      success: (data) -> $('div#workflowtasks').html(data)
  false

  selectfunction2 = () ->
    selected = $(this)
    workflow = $('input#workflow_id').val()
    step = selected.find(':selected').val()
    step_on = selected.data("onstep")
    step_id = selected.data("parentstep")
    if step_on is "success"
      add_on_success(workflow, step, step_id)
    if step_on is "failure"
      add_on_failure(workflow, step, step_id)
    if step_on is "completed"
      add_on_completed(workflow, step, step_id)
    else
      false
  false

  $('body').on 'change',
    '.selectable'
    selectfunction2
  false

  selectfunction = () ->
    clicked = $(this)
    if clicked.attr('id') is "removestep"
      removestep(clicked)
    if clicked.attr('id') is "remove_on_success_step"
      remove_on_success(clicked)
    if clicked.attr('id') is "remove_on_failure_step"
      remove_on_failure(clicked)
    if clicked.attr('id') is "remove_on_completed_step"
      remove_on_completed(clicked)
    else
      false
  false

  $('body').on 'click',
    '.clickable'
    selectfunction
  false

