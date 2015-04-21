$ ->
  refreshcistack = () ->
    $.get '/cistacks/tablelist', (data) -> $("div#cistacktablelist").html(data)
    setTimeout(refreshcistack, 5000)
  false

  $(document).ready refreshcistack

  
