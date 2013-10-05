$ ->

  $("#suggest_input").autocomplete(
    minLength: 0
    source: (request, response) ->
      $.ajax
        url: "http://suggest.vagalume.com.br/json"
        dataType: "jsonp"
        data:
          q: request.term

        success: (data) ->
          d = data.response.docs.filter (el) ->
            !el.title
          response $.map(d, (item) ->
            label: item.band,
            url: item.url
          )

    focus: (event, ui) ->
      $("#suggest_input").val ui.item.label
      false

    select: (event, ui) ->
      location.href = '/artist?artist='+ui.item.label
      false
  ).data("ui-autocomplete")._renderItem = (ul, item) ->
    $("<li>").append("<a href='/artist?artist="+item.label+"'><img src='http://s2.vagalume.com"+item.url+"images/profilew40.jpg' /><strong>" + item.label + "<strong></a>").appendTo ul