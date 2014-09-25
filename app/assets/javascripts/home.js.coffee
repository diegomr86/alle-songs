#= require modernizr.custom
#= require jquery
#= require jquery_ujs
#= require http://code.jquery.com/ui/1.10.3/jquery-ui.js
#= require bootstrap
#= require pixel-admin
#= require alert
#= require toucheffects
#= require rx
#= require rx.time
#= require rx.coincidence
#= require suggest
#= require angular
#= require angular-resource
#= require angular-route
#= require angular-sanitize
#= require angular-cookies
#= require angular-will-paginate
#= require xeditable
#= require devise
#= require ui-bootstrap-tpls-0.11.0.min
#= require ngDraggable
#= require lastfm.api.js
#= require lastfm.api.cache
#= require lastfm.api.md5
#= require lastFM
#= require typeahead
#= require alert
#= require app

createPlayer = ->

  # Load the IFrame Player API code asynchronously.
  tag = document.createElement("script")
  tag.src = "//www.youtube.com/iframe_api"
  firstScriptTag = document.getElementsByTagName("script")[0]
  firstScriptTag.parentNode.insertBefore tag, firstScriptTag
  return

$ ->

  $('[title]').tooltip()

  createPlayer()

  $("#forward").click ->
    loadNext true
  $("#backward").click ->
    loadPrevious true
  $("#suggest_input").focus(->
    $('.page-header').stop().animate
      backgroundColor: "#f3f3f3"
      borderColor: "#fff"
    , 600, ->
      $('.page-header').animate
        backgroundColor: "#fff"
        borderColor: "#ececec"
      , 600
      return

  )
  $("#suggest_input").focus();
