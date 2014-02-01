disable_submit = (el) ->
  bt = $(el).find("[type=\"submit\"]")
  bt.attr "data-bt_submit-status", bt.val()
  bt.val "..."
  bt.attr "disabled", "disabled"
enable_submit = (el) ->
  bt = $(el).find("[type=\"submit\"]")
  bt.val bt.attr("data-bt_submit-status")
  bt.removeAttr "disabled"
load_functions = (el) ->
  $(el).find("[data-toggle-item]").click ->
    $(el).find($(this).attr("data-toggle-item")).toggle();

$ ->

  $('a[data-remote]').on( 'ajax:before', () ->
    console.log('aaa')
    if ($(this).attr('data-loading') && $($(this).attr('data-loading')))
      $($(this).attr('data-loading')).html '<div class="loading"></div>'
    else
      $($(this).attr('data-target')).children().hide()
      $($(this).attr('data-target')).append '<div class="loading"></div>'
  ).on 'ajax:complete', (xhr, status) ->
    console.log xhr
    el = this
    if status.status == 401

      FB.login ((response) ->
        if response.authResponse
          console.log response.authResponse
          console.log "Connected! Hitting OmniAuth callback (GET users/auth/facebook/callback)..."
          $.getJSON "users/auth/facebook/callback?"+$.param({ access_token : response.authResponse.accessToken }), (json) ->
            console.log JSON.stringify(json)
            $(this).click()

      ),
        # Do some other stuff here (call more json, load in more elements, etc)
        scope: "email,read_stream" # These are the permissions you are requesting

    else
      $($(this).attr('data-target')).hide()
      $($(this).attr('data-target')).html status.responseText
      $($(this).attr('data-target')).fadeIn 1000

      load_functions $($(this).attr('data-target'))
      $($(this).attr('data-loading')).html ''

  $("form[data-remote]").on("ajax:beforeSend", (event, data, textStatus, jqXHR) ->
    disable_submit this
  ).on("ajax:error", (event, jqXHR, textStatus, errorThrown) ->
    enable_submit this
  ).on "ajax:complete", (event, jqXHR, textStatus) ->
    enable_submit this
    if $(this).attr('data-target')
      $($(this).attr('data-target')).hide()
      $($(this).attr('data-target')).html jqXHR.responseText
      $($(this).attr('data-target')).fadeIn 1000
    load_functions $($(this).attr('data-target'))