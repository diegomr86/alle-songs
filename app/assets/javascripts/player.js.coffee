$ ->
  $('li.music_link').removeClass('active')
  $('li.music_link[data-code="'+$("#player_container").data('code')+'"]').addClass('active')


#  $("#play").click ->
#    ytplayer.playVideo()
#  $("#pause").click ->
#    ytplayer.pauseVideo()

#  params = allowScriptAccess: "always"
#  video_id = $("#player_container").data('id')
#  swfobject.embedSWF "http://www.youtube.com/v/"+video_id+"&enablejsapi=1&playerapiid=ytplayer&autoplay=true", "ytplayer", "589", "365", "8", null, null, params
#  ytplayer.addEventListener "onStateChange", onytplayerStateChange = (newState) ->
#    alert "Player's new state: " + newState

  setInterval (->
    NProgress.set(((ytplayer.getCurrentTime() * 100) / ytplayer.getDuration()) / 100)
  ), 1000


