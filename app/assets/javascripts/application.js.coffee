#= require lastfm.api.js
#= require lastfm.api.cache
#= require lastfm.api.md5
#= require lastFM
#= require typeahead
#= require alert
#= require app

# teste
createPlayer = ->

  # tetst
  # Load the IFrame Player API code asynchronously.
  tag = document.createElement("script")
  tag.src = "//www.youtube.com/iframe_api"
  firstScriptTag = document.getElementsByTagName("script")[0]
  firstScriptTag.parentNode.insertBefore tag, firstScriptTag
  return

$ ->

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
