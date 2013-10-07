var refreshIntervalId;
var ytplayer;
var firstVidId;
var playId;
var theScrollPane;
var videosScrollbar;
var relatedScrollbar;

/* --- HELPERS --------------------------------------------------- */
// detect iOS
var user_agent = navigator.userAgent.toLowerCase();
var is_iPhone = (user_agent.indexOf('iphone') != -1);
var is_iOS = ((user_agent.indexOf('iphone') != -1) || (user_agent.indexOf('ipad') != -1));

// timer helper
var waitForFinalEvent = (function () {
    var timers = {};
    return function (callback, ms, uniqueId) {
        if (timers[uniqueId]) {
            clearTimeout (timers[uniqueId]);
        }
        timers[uniqueId] = setTimeout(callback, ms);
    };
})();

// console.log override
if (typeof console == "undefined") {
    window.console = {
        log: function () {}
    };
}

// fetches url params
function getUrlParams() {
    data = new Array();
    data['video'] = false;
    data['search'] = false;
    // get data from url
    hash = window.location.hash;

    var parts = hash.split('&');
    for (var i=0;i<parts.length;i++) {
        var p = parts[i];
        if (p.indexOf('#vid-random') > -1)  {
            data['video'] = getRandomVideoId();
        } else if (p.indexOf('#v=') > -1) {
            var id = p.replace('#v=', '');
            data['video'] = p.replace('#v=', '');
        } else if (p.indexOf('#vid-') > -1) {
            var id = p.replace('#vid-', '');
            data['video'] = p.replace('#vid-', '');
        } else if (p.indexOf('search=') > -1) {
            data['search'] = p.replace('search=', '');
        }
    }
    return data;
}

/* --- PLAYER --------------------------------------------------- */
function createPlayer(container_id) {
    // Load the IFrame Player API code asynchronously.
    var tag = document.createElement('script');
    tag.src = "//www.youtube.com/iframe_api";
    var firstScriptTag = document.getElementsByTagName('script')[0];
    firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);
}

function videoInfo(url) {
}

/* ----- NEW API ---------- */
// This function creates an <iframe> (and YouTube player) after the API code downloads.
var player;
function onYouTubeIframeAPIReady() {

    $.getJSON( $('.albuns li.music_link.active a').attr('href'), function( data ) {
        if (data.video) {
            player = new YT.Player('player_container', {
                height: '350',
                width: '100%',
                videoId: data.video.unique_id,
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

            displayVideoMeta($('.albuns li.music_link.active'), data);
        }
    });
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
        $('#play_pause i').removeClass('icon-pause').addClass('icon-play');
        $('#play_pause').unbind().click(function(){
            player.playVideo();
        });
        clearInterval(refreshIntervalId);
    }

    if (event.data == YT.PlayerState.ENDED) {

        loadNext();
    }
}
// Used for detecting
function onPlayerError(event) {
    if (event.data == 150 || event.data == 101) {
        // can't play this video, skip to next.
        $('.albuns li.music_link.active').css('opacity','.5');
        $('#player_container').after('<div id="errormsg">You cannot play that video, its probably restricted in your country. Skipping to the next video in the list...</div>');
        loadNext(true); // true means we ignore autojump in this case

        $('#errormsg').delay(2000).fadeOut('slow', function() {
            $('#errormsg').remove();
        });
    }
}

function scrollToVideo(id) {
    // scroll to element
}

function displayVideoMeta(el, data) {

    console.log(data)

    if (data != 'undefined') {
        $('.albuns li.music_link').removeClass('active');
        $('.albuns li.music_link a i.status').removeClass('icon-play')
        $('.albuns li.music_link a i.status:not(.icon-remove)').addClass('icon-music')
        $('.albuns .panel-collapse').removeClass('in');

        el.find('a i.status').removeClass('icon-music');
        el.find('a i.status:not(.icon-remove)').addClass('icon-play');
        el.addClass('active');
        $(el.data('target')).addClass('in');

        if (data.info.art) {

            lyric = ''
            title = data.info.art.name;
            subtitle = el.find('span').text();
            if (data.info.mus && data.info.type == "exact") {
                lyric = data.info.mus[0].text;
            } else {
                lyric = "Lyrics not found";
            }

            title += ' | ' + el.find('span').text();

            $('title').text(title);
            $('#lyrics header h3').html("<i class='icon-play'></i> "+title);
            $('#lyric_text').text(lyric)
        }
    }
}

function loadVideo(el) {

    NProgress.start();

    $.getJSON(el.find('a').attr('href'), function( data ) {
        NProgress.done();
        if (data.video) {
            displayVideoMeta(el, data);
            player.loadVideoById(data.video.unique_id);
            if (is_iPhone) {
                window.scrollTo(0, 0);
            }
        } else {
            el.find('a i.status').removeClass('icon-play');
            el.find('a i.status').addClass('icon-remove');
            el.attr('title', 'Song not found')
            loadVideo(nextItem(el));
        }
        NProgress.remove();
    });
}

function nextItem(current) {
    var list = $('.albuns li.music_link');
    return list.eq( list.index(current) + 1 );
}

function previousItem(current) {
    var list = $('.albuns li.music_link');
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
        document.location.href = $(artists[n]).attr('href') + "#vid-random";
    } else {
        // go to previous video in list
        if ($('.albuns li.music_link').length > 1) {
            var current = $('.albuns li.music_link.active');
            if (current) {
                previous = previousItem(current)
                console.log(previous.find('a').attr('href'))
                if (previous.find('a').attr('href')) {
                    loadVideo(previous)

                } else {
                    loadVideo($('.albuns li.music_link:first'));
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
        document.location.href = $(artists[n]).attr('href') + "#vid-random";
    } else {
        // go to next video in list
        if ($('.albuns li.music_link').length > 1) {
            var current = $('.albuns li.music_link.active');
            if (current) {
                next = nextItem(current)
                console.log(next.find('a').attr('href'))
                if (next.find('a').attr('href')) {
                    loadVideo(next)

                } else {
                    loadVideo($('.albuns li.music_link:first'));
                }

            }
        }

    }
}
// get a random video id
function getRandomVideoId() {
    var videos = $('.albuns li.music_link a');
    var maxResult = (videos.length > 10) ? 10 : videos.length;
    var n = Math.floor(Math.random()*maxResult);
    var id = $(videos[n]).attr('href');

    return id;
}


/* create events on video list elements */
function setupList() {
    $('.albuns li.music_link a').on("click", function(e) {
        e.preventDefault();
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
