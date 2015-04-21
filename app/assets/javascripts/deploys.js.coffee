# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('select#deploy_workflow_id').change ->
    workflow = $('select#deploy_workflow_id option:selected').val()
    $.get '/deploys/getinput/' + workflow, (data) -> $('div#deployinput').html(data)
  false 
