$ ->

  $("#suggest_form").submit ->
    location.href = "/"+$(this).find('#suggest_input').val().split("/").join("+")
    false

  $("#suggest_input").focus().autocomplete(
    minLength: 0
    source: (request, response) ->
      if request.term
        $.get("/search",
          query: request.term
        ).done (data) ->
          $('#artists').html data

  )