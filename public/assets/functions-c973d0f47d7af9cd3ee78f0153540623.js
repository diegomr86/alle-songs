function createPlayer(){var e=document.createElement("script");e.src="//www.youtube.com/iframe_api";var a=document.getElementsByTagName("script")[0];a.parentNode.insertBefore(e,a)}function renderPlayer(e){return new YT.Player("player_container",{width:"100%",videoId:e,playerVars:{autoplay:1,iv_load_policy:3,rel:0,showinfo:1},events:{onReady:onPlayerReady,onStateChange:onPlayerStateChange,onError:onPlayerError}})}function onYouTubeIframeAPIReady(){loadVideo($(".albums li.music_link.active"))}function onPlayerReady(e){is_iPhone||e.target.playVideo()}function onPlayerStateChange(e){console.log(e.data),e.data==YT.PlayerState.PLAYING?($("#play_pause i").removeClass("icon-play").addClass("icon-pause"),$("#play_pause").unbind().click(function(){player.pauseVideo()}),refreshIntervalId=setInterval(function(){NProgress.set(100*player.getCurrentTime()/player.getDuration()/100)},1e3)):(clearInterval(refreshIntervalId),$("#play_pause i").removeClass("icon-pause").addClass("icon-play"),$("#play_pause").unbind().click(function(){player.playVideo()})),e.data==YT.PlayerState.ENDED&&loadNext()}function onPlayerError(e){console.log("asdfasdfasdf"),console.log(e.data),(150==e.data||101==e.data)&&($(".albums li.music_link.active").css("opacity",".5"),$("#player_container").after('<div id="errormsg">You cannot play that video, its probably restricted in your country. Skipping to the next video in the list...</div>'),loadNext(!0),$("#errormsg").delay(2e3).fadeOut("slow",function(){$("#errormsg").remove()}))}function displayVideoMeta(e,a){console.log("aaa"),console.log("undefined"!=a),"undefined"!=a&&($(".albums li.music_link").removeClass("active"),$(".albums li.music_link a i.status").removeClass("icon-play"),$(".albums li.music_link a i.status:not(.icon-exclamation)").addClass("icon-music"),$(".albums .panel-collapse").removeClass("in"),e.find("a i.status").removeClass("icon-music").removeClass("icon-spinner").removeClass("icon-spin"),e.find("a i.status:not(.icon-exclamation)").addClass("icon-play"),e.addClass("active"),$(e.data("target")).addClass("in"),artist=$(".artist .info h2").text(),subtitle=e.find(".title").text(),title=artist+" - "+subtitle,$("title").text(title),lyric="",translation_text="",a.info.mus&&"exact"==a.info.type?(lyric=a.info.mus[0].text,lyric+='<br/><br/><p><a style="font-size:10px;color:#000;text-decoration:none;font-weight:bold" target=_blank href="'+a.info.mus[0].url+'"><img src="http://www.vagalume.com.br/images/logo_small2.jpg" alt="Vagalume"><br/>Letras de Músicas</a></p>',a.info.mus[0].translate&&(translation_text=a.info.mus[0].translate[0].text.replace("[","<b>").replace("]","</b>"))):lyric="Letra não encontrada",$("#song_info header h4").html("<i class='icon-youtube-play'></i> "+title),$("#lyrics header h4").html("<i class='icon-file-text'></i> Letra - "+subtitle),$("#lyric_text").html(lyric),$("#translation_text").html(translation_text),ga("send",{hitType:"event",eventCategory:"play",eventAction:artist,eventLabel:subtitle}))}function setError(e){e.find("a i.status").removeClass("icon-play").removeClass("icon-spinner").removeClass("icon-spin"),e.find("a i.status").addClass("icon-exclamation"),e.attr("title","Song not found"),loadVideo(nextItem(e))}function loadVideo(e){NProgress.start(),$.getJSON(e.find("a").data("href"),function(a){NProgress.done(),displayVideoMeta(e,a),a.video?("undefined"==typeof player?player=renderPlayer(a.video):player.loadVideoById(a.video),is_iPhone&&window.scrollTo(0,0)):setError(e),NProgress.remove()})}function nextItem(e){var a=$(".albums li.music_link");return a.eq(a.index(e)+1)}function previousItem(e){var a=$(".albums li.music_link");return a.index(e)>0?a.eq(a.index(e)-1):void 0}function loadPrevious(e){if(e="undefined"!=typeof e?e:!1,$("a#ajlink").hasClass("on")&&0==e){var a=$("ul#related_list li a"),t=Math.floor(Math.random()*a.length);$(a[t]).addClass("active"),document.location.href=$(a[t]).data("href")+"#vid-random"}else if($(".albums li.music_link").length>1){var i=$(".albums li.music_link.active");i&&(previous=previousItem(i),previous.find("a").data("href")?loadVideo(previous):loadVideo($(".albums li.music_link:first")))}}function loadNext(e){if(e="undefined"!=typeof e?e:!1,$("a#ajlink").hasClass("on")&&0==e){var a=$("ul#related_list li a"),t=Math.floor(Math.random()*a.length);$(a[t]).addClass("active"),document.location.href=$(a[t]).data("href")+"#vid-random"}else if($(".albums li.music_link").length>1){var i=$(".albums li.music_link.active");i&&(next=nextItem(i),console.log(next.find("a").data("href")),next.find("a").data("href")?loadVideo(next):loadVideo($(".albums li.music_link:first")))}}function setupList(){$(".albums li.music_link a").on("click",function(e){e.preventDefault(),$(this).find(".status").removeClass("icon-play").removeClass("icon-music").removeClass("icon-exclamation"),$(this).find(".status").addClass("icon-spinner").addClass("icon-spin"),loadVideo($(this).parent())})}function setupAutojump(){0!=$("a#ajlink").length&&("yes"==readCookie("autojump")&&$("a#ajlink").addClass("on"),$("a#ajlink").click(function(e){e.preventDefault(),$("a#ajlink").hasClass("on")?(createCookie("autojump","no",32),$("a#ajlink").removeClass("on")):(createCookie("autojump","yes",32),$("a#ajlink").addClass("on"))}))}var refreshIntervalId,player,user_agent=navigator.userAgent.toLowerCase(),is_iPhone=-1!=user_agent.indexOf("iphone");"undefined"==typeof console&&(window.console={log:function(){}});