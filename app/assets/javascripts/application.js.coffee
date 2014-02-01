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
#= require ajax

loadScrollPane = ->
#  $('.scroll-pane').jScrollPane mouseWheelSpeed: 20, autoReinitialise: true if $('.ui-layout-center')


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
