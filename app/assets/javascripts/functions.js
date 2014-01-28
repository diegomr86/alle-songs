var refreshIntervalId;
var player;

/* --- HELPERS --------------------------------------------------- */
// detect iOS
var user_agent = navigator.userAgent.toLowerCase();
var is_iPhone = (user_agent.indexOf('iphone') != -1);

// console.log override
if (typeof console == "undefined") {
    window.console = {
        log: function () {}
    };
}

/* --- PLAYER --------------------------------------------------- */
function createPlayer() {
    // Load the IFrame Player API code asynchronously.
    var tag = document.createElement('script');
    tag.src = "//www.youtube.com/iframe_api";
    var firstScriptTag = document.getElementsByTagName('script')[0];
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
}

/* ----- NEW API ---------- */
// This function creates an <iframe> (and YouTube player) after the API code downloads.

function renderPlayer(vid) {
    return new YT.Player('player_container', {
        width: '100%',
        videoId: vid,
        playerVars: {
            'autoplay': 1,
            'iv_load_policy': 3,
            'rel': 0,
            'showinfo': 1
        },
        events: {
            'onReady': onPlayerReady,
            'onStateChange': onPlayerStateChange,
            'onError': onPlayerError
        }
    });
}
function onYouTubeIframeAPIReady() {

    loadVideo($('.albums li.music_link.active'));

}
// The API will call this function when the video player is ready.
function onPlayerReady(event) {
    if (!is_iPhone) {
        event.target.playVideo();
    }
}

// The API calls this function when the player's state changes.
function onPlayerStateChange(event) {

    console.log(event.data)

    if (event.data == YT.PlayerState.PLAYING) {
        $('#play_pause i').removeClass('icon-play').addClass('icon-pause');
        $('#play_pause').unbind().click(function(){
            player.pauseVideo();
        });
        refreshIntervalId = setInterval(function(){
            NProgress.set(((player.getCurrentTime() * 100) / player.getDuration()) / 100)
        }, 1000);

    } else {
        clearInterval(refreshIntervalId);

        $('#play_pause i').removeClass('icon-pause').addClass('icon-play');
        $('#play_pause').unbind().click(function(){
            player.playVideo();
        });
    }

    if (event.data == YT.PlayerState.ENDED) {
        loadNext();
    }


}
// Used for detecting
function onPlayerError(event) {
    console.log('asdfasdfasdf');
    console.log(event.data);
    if (event.data == 150 || event.data == 101) {
        // can't play this video, skip to next.
        $('.albums li.music_link.active').css('opacity','.5');
        $('#player_container').after('<div id="errormsg">You cannot play that video, its probably restricted in your country. Skipping to the next video in the list...</div>');
        loadNext(true); // true means we ignore autojump in this case

        $('#errormsg').delay(2000).fadeOut('slow', function() {
            $('#errormsg').remove();
        });
    }
}

function displayVideoMeta(el, data) {

    console.log('aaa');
    console.log(data != 'undefined');
    if (data != 'undefined') {
        $('.albums li.music_link').removeClass('active');
        $('.albums li.music_link a i.status').removeClass('icon-play')
        $('.albums li.music_link a i.status:not(.icon-exclamation)').addClass('icon-music')
        $('.albums .panel-collapse').removeClass('in');

        el.find('a i.status').removeClass('icon-music').removeClass('icon-spinner').removeClass('icon-spin');
        el.find('a i.status:not(.icon-exclamation)').addClass('icon-play');
        el.addClass('active');
        $(el.data('target')).addClass('in');

        artist = $('.artist .info h2').text();
        subtitle = el.find('.title').text();
        title = artist + ' - ' + subtitle;

        $('title').text(title);

        lyric = ''
        translation_text = ''

        if (data.info.mus && data.info.type == "exact") {
            lyric = data.info.mus[0].text;
            lyric += '<br/><br/><p><a style="font-size:10px;color:#000;text-decoration:none;font-weight:bold" target=_blank href="'+data.info.mus[0].url+'"><img src="http://www.vagalume.com.br/images/logo_small2.jpg" alt="Vagalume"><br/>Letras de Músicas</a></p>'

            if (data.info.mus[0].translate) {
                translation_text = data.info.mus[0].translate[0].text.replace('[', '<b>').replace(']', '</b>');
            }


        } else {
            lyric = "Letra não encontrada";
        }

        $('#song_info header h4').html("<i class='icon-youtube-play'></i> "+title);
        $('#lyrics header h4').html("<i class='icon-file-text'></i> Letra - "+subtitle);
        $('#lyric_text').html(lyric)
        $('#translation_text').html(translation_text)

        ga('send', {
            'hitType': 'event',          // Required.
            'eventCategory': 'play',   // Required.
            'eventAction': artist,      // Required.
            'eventLabel': subtitle
        });
    }
}

function setError(el) {
    el.find('a i.status').removeClass('icon-play').removeClass('icon-spinner').removeClass('icon-spin');
    el.find('a i.status').addClass('icon-exclamation');
    el.attr('title', 'Song not found')
    loadVideo(nextItem(el));
}

function loadVideo(el) {

    NProgress.start();

    $.getJSON(el.find('a').data('href'), function( data ) {
        NProgress.done();
        displayVideoMeta(el, data);
        if (data.video) {
            if (typeof player == "undefined")
                player = renderPlayer(data.video);
            else
                player.loadVideoById(data.video);

            if (is_iPhone) {
                window.scrollTo(0, 0);
            }
        } else {
            setError(el);
        }
        NProgress.remove();
    });
}

function nextItem(current) {
    var list = $('.albums li.music_link');
    return list.eq( list.index(current) + 1 );
}

function previousItem(current) {
    var list = $('.albums li.music_link');
    if (list.index(current) > 0) {
        return list.eq( list.index(current) - 1 );
    }
}

// load previous video in the list
function loadPrevious(ignoreAutojump) {
    ignoreAutojump = typeof ignoreAutojump !== 'undefined' ? ignoreAutojump : false;

    if ($('a#ajlink').hasClass('on') && ignoreAutojump == false) {
        // jump to related artist
        var artists = $('ul#related_list li a');
        var n = Math.floor(Math.random()*artists.length);
        $(artists[n]).addClass('active');
        document.location.href = $(artists[n]).data('href') + "#vid-random";
    } else {
        // go to previous video in list
        if ($('.albums li.music_link').length > 1) {
            var current = $('.albums li.music_link.active');
            if (current) {
                previous = previousItem(current)
                if (previous.find('a').data('href')) {
                    loadVideo(previous)
                } else {
                    loadVideo($('.albums li.music_link:first'));
                }

            }
        }

    }
}

// load next video in the list
function loadNext(ignoreAutojump) {
    ignoreAutojump = typeof ignoreAutojump !== 'undefined' ? ignoreAutojump : false;

    if ($('a#ajlink').hasClass('on') && ignoreAutojump == false) {
        // jump to related artist
        var artists = $('ul#related_list li a');
        var n = Math.floor(Math.random()*artists.length);
        $(artists[n]).addClass('active');
        document.location.href = $(artists[n]).data('href') + "#vid-random";
    } else {
        // go to next video in list
        if ($('.albums li.music_link').length > 1) {
            var current = $('.albums li.music_link.active');
            if (current) {
                next = nextItem(current)
                console.log(next.find('a').data('href'))
                if (next.find('a').data('href')) {
                    loadVideo(next)

                } else {
                    loadVideo($('.albums li.music_link:first'));
                }

            }
        }

    }
}

/* create events on video list elements */
function setupList() {
    $('.albums li.music_link a').on("click", function(e) {
        e.preventDefault();
        $(this).find('.status').removeClass('icon-play').removeClass('icon-music').removeClass('icon-exclamation')
        $(this).find('.status').addClass('icon-spinner').addClass('icon-spin')
        loadVideo($(this).parent());
    });
}

function setupAutojump() {
    if ($('a#ajlink').length != 0) {
        if (readCookie('autojump') == 'yes') {
            $('a#ajlink').addClass('on');
        }
        $('a#ajlink').click(function(e) {
            e.preventDefault();
            if ($('a#ajlink').hasClass('on')) {
                createCookie('autojump','no',32);
                $('a#ajlink').removeClass('on');
            } else {
                createCookie('autojump','yes',32);
                // console.log('create cookie: yes');
                $('a#ajlink').addClass('on');
            }
        });
    }
}
