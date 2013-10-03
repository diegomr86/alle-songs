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
#= require jquery
#= require jquery_ujs
#= require nprogress

$ ->

  NProgress.configure({ showSpinner: false, trickle: true });

  $('a[data-remote]').on( 'ajax:before', () ->
    $($(this).attr('data-target')).html "<i class='icon-spinner icon-spin icon-large icon-5'></i>"

  ).on 'ajax:complete', (xhr, status) ->
    $($(this).attr('data-target')).hide()
    $($(this).attr('data-target')).html status.responseText
    $($(this).attr('data-target')).fadeIn 1000

  $('a[data-remote][data-autoload="true"]').click()