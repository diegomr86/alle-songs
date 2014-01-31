# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# the compiled file.
#
# WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
# GO AFTER THE REQUIRES BELOW.
#
#= require swfobject/swfobject
#= require jquery.layout
#= require nprogress
#= require jquery.mousewheel
#= require jquery.jscrollpane.min
#= require functions
#= require suggest
#= require facebook

loadScrollPane = ->
#  $('.scroll-pane').jScrollPane mouseWheelSpeed: 20, autoReinitialise: true if $('.ui-layout-center')

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

#  $("body").layout applyDefaultStyles: false, closable: false, spacing_open: 0, west__size: .25, east__size: .25

  setupList()

  loadScrollPane()

  NProgress.configure({ showSpinner: false, trickle: true });

  createPlayer()

  setupAutojump()

  $("#forward").click ->
    loadNext true
  $("#backward").click ->
    loadPrevious true


  $('a[data-remote]').on( 'ajax:before', () ->
    console.log('aaa')
    if ($(this).attr('data-loading') && $($(this).attr('data-loading')))
      $($(this).attr('data-loading')).html '<div class="loading"></div>'
    else
      $($(this).attr('data-target')).children().hide()
      $($(this).attr('data-target')).append '<div class="loading"></div>'
  ).on 'ajax:complete', (xhr, status) ->
    if status.status == 401

      FB.login ((response) ->
        if response.authResponse
          console.log response.authResponse
          console.log "Connected! Hitting OmniAuth callback (GET users/auth/facebook/callback)..."
          $.getJSON "users/auth/facebook/callback", (json) ->
            $("#results").html JSON.stringify(json)

      ),
        # Do some other stuff here (call more json, load in more elements, etc)
        scope: "email,read_stream" # These are the permissions you are requesting

    else
      $($(this).attr('data-target')).hide()
      $($(this).attr('data-target')).html status.responseText
      $($(this).attr('data-target')).fadeIn 1000

      load_functions $($(this).attr('data-target'))
      $($(this).attr('data-loading')).html ''

#  $("form[data-remote]").on("ajax:beforeSend", (event, data, textStatus, jqXHR) ->
#    disable_submit this
#  ).on("ajax:error", (event, jqXHR, textStatus, errorThrown) ->
#    enable_submit this
#  ).on "ajax:complete", (event, jqXHR, textStatus) ->
#    enable_submit this
#    if $(this).attr('data-target')
#      $($(this).attr('data-target')).hide()
#      $($(this).attr('data-target')).html jqXHR.responseText
#      $($(this).attr('data-target')).fadeIn 1000
#    load_functions $($(this).attr('data-target'))