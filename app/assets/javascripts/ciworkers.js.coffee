$ ->
  refreshciworker = () ->
    $.get '/ciworkers/tablelist', (data) -> $("div#ciworkertablelist").html(data)
    setTimeout(refreshciworker, 5000)
  false

  $(document).ready refreshciworker
