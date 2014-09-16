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
#= require ui-bootstrap-tpls-0.11.0.min
#= require ngDraggable
#= require lastfm.api.js
#= require lastfm.api.cache
#= require lastfm.api.md5
#= require lastFM
#= require typeahead
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
