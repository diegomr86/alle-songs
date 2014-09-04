var app = angular.module('allesongs', ['ngResource', 'ngRoute','ui.bootstrap'])

app.controller('TracksCtrl', ['$scope', '$resource', '$location', function($scope, $resource, $location) {

    $scope.go = function ( path ) {
        $location.path( path );
    };

    var Track = $resource('/api/tracks/:id');

    $scope.tracks = Track.query();

    $scope.$watch('current_track', function(current_track, old_track) {
        if (current_track != undefined) {
            $.getJSON(current_track.url, function (data) {
                $scope.displayVideoMeta(current_track, data);
                if (data.video) {
                    if (typeof player == "undefined")
                        player = $scope.renderPlayer(data.video);
                    else
                        player.loadVideoById(data.video);

                    if ($scope.is_iPhone) {
                        window.scrollTo(0, 0);
                    }
                } else {
                    $scope.setError(current_track);
                }
            });
        }
    });

    $scope.$watch('playing', function(current_track, old_track) {
        console.log(current_track+' - '+old_track)
    });

    $scope.play = function(track) {
        if (track != undefined)
            $scope.current_track = track;
        else if ($scope.tracks[0] != undefined)
            $scope.current_track = $scope.tracks[0];
    }

    $scope.addToPlaylist = function(t, play) {

        console.log(t)
        var track = new Track({ name: t.name, artist: t.artist.name, picture: (t.image ? t.image[3]['#text'] : ''), duration: (t.duration) });
        Track.save(track, function(t) {
            //$scope should be accessible here
            $scope.tracks.push(t);
            setTimeout(function() {
                $("#playlist").slimScroll({ scrollTo: '10000px' });
            }, 100)
            if (play) {
                $scope.play(t)
            }
        })
    };

    $scope.addAlbumToPlaylist = function(a, play) {
        console.log(a)
        lastfm.album.getInfo({album: a.name, artist: a.artist.name}, { success: function(data){
            angular.forEach(data.album.tracks.track, function(track, key) {
                track.image = a.image
                console.log(track)
                $scope.addToPlaylist(track, (key == 0 && play))
            });

            $scope.$digest()
        }});
    };

    $scope.addArtistToPlaylist = function(a, play) {
        console.log(a)
        lastfm.artist.getTopTracks({artist: a.name}, { success: function(data){
            angular.forEach(data.toptracks.track, function(track, key) {
                console.log(track)
                $scope.addToPlaylist(track, (key == 1 && play))
            });

            $scope.$digest()
        }});
    };

    $scope.clearPlaylist = function() {
        angular.forEach($scope.tracks, function(track, key) {
            console.log(track)
            $scope.removeFromPlaylist(track)
        });
    };

    $scope.removeFromPlaylist = function(track) {
        $scope.tracks.splice($scope.tracks.indexOf(track), 1);
        Track.delete(track)
    };



    $scope.setError = function (track) {
        console.log('error...')
        console.log(track)
    }

    $scope.loadNext = function () {
        if ($scope.tracks.length > 1) {
            var next = $scope.tracks.indexOf($scope.current_track) + 1
            if ($scope.tracks[next] != undefined) {
                $scope.play($scope.tracks[next])
            } else {
                $scope.play($scope.tracks[0])
            }

        }
    }

    $scope.loadPrevious = function () {
        if ($scope.tracks.length > 1) {
            var previous = $scope.tracks.indexOf($scope.current_track) - 1
            if (previous >= 0) {
                $scope.play($scope.tracks[previous])
            } else {
                $scope.play($scope.tracks.length - 1)
            }

        }
    }

    $scope.displayVideoMeta = function (track, data) {

        if (data != 'undefined') {

            artist = track.artist;
            subtitle = track.name;
            title = artist + ' - ' + subtitle;

            $('title').text(title);

            lyric = ''
            translation_text = ''

            if (data.info && data.info.mus && data.info.type == "exact") {
                lyric = data.info.mus[0].text;
                lyric += '<br/><br/><p><a style="font-size:10px;color:#000;text-decoration:none;font-weight:bold" target=_blank href="'+data.info.mus[0].url+'"><img src="http://www.vagalume.com.br/images/logo_small2.jpg" alt="Vagalume"><br/>Letras de Músicas</a></p>'

                if (data.info.mus[0].translate) {
                    translation_text = data.info.mus[0].translate[0].text.replace('[', '<b>').replace(']', '</b>');
                }


            } else {
                lyric = "Letra não encontrada";
            }

        }
    }

    $scope.renderPlayer = function (vid) {
        return new YT.Player('player_container', {
            width: '100%',
            height: '280px',
            videoId: vid,
            playerVars: {
                'autoplay': 1,
                'iv_load_policy': 3,
                'rel': 0,
                'showinfo': 1
            },
            events: {
                'onReady': $scope.onPlayerReady,
                'onStateChange': $scope.onPlayerStateChange,
                'onError': $scope.onPlayerError
            }
        });
    }

    // The API will call this function when the video player is ready.
    $scope.onPlayerReady = function(event) {
        if (!$scope.is_iPhone) {
            event.target.playVideo();
        } else {
            player.playVideo();
        }
    }

    // The API will call this function when the video player is ready.
    $scope.is_iPhone = function() {
        (navigator.userAgent.toLowerCase().indexOf('iphone') != -1);
    }

    // The API will call this function when the video player is ready.
    $scope.pauseVideo = function() {
        player.pauseVideo();
    }

    // The API will call this function when the video player is ready.
    $scope.playVideo = function() {
        player.playVideo();
    }

    // The API calls this function when the player's state changes.
    $scope.onPlayerStateChange = function (event) {
        $scope.playing = (event.data == 1)

        if (event.data == YT.PlayerState.ENDED) {
            $scope.loadNext();
        }

        $scope.$digest()


    }

    $scope.onPlayerError = function (event) {
        if (event.data == 150 || event.data == 101) {
            // can't play this video, skip to next.
            $('.albums li.music_link.active').css('opacity','.5');
            $('#player_container').after('<div id="errormsg">You cannot play that video, its probably restricted in your country. Skipping to the next video in the list...</div>');
            $scope.loadNext();

            $('#errormsg').delay(2000).fadeOut('slow', function() {
                $('#errormsg').remove();
            });
        }
    }

}]);

app.controller('ArtistCtrl', ['$scope', '$routeParams', function($scope, $routeParams) {
    lastfm.artist.getInfo({artist: $routeParams.artist_name}, {success: function(data){
        $scope.artist = data.artist
        console.log($scope.artist)
        $scope.$digest()

        lastfm.artist.getTopAlbums({artist: $scope.artist.name}, {success: function(data){
            $scope.top_albums = data.topalbums.album
            console.log($scope.top_albums)
            $scope.$digest()
        }});
    }});

    $scope.load_top_tracks = function () {
        if (!$scope.top_tracks) {
            lastfm.artist.getTopTracks({artist: $scope.artist.name}, {success: function (data) {
                $scope.top_tracks = data.toptracks.track
                console.log($scope.top_tracks)
                $scope.$digest()
            }});
        }
    }

    $scope.load_events = function () {
        if (!$scope.events) {
            lastfm.artist.getEvents({artist: $scope.artist.name}, {success: function(data){
                $scope.events = data.events.event
                console.log($scope.events)
                $scope.$digest()
            }});
        }
    }
}]);

app.controller('AlbumCtrl', ['$scope', '$resource', function($scope, $resource) {

}]);

app.config(function($routeProvider, $locationProvider) {
    $routeProvider.when('/:artist_name', {
        templateUrl: function(params){ return '/' + params.artist_name + '?angular=true'; },
        controller: 'ArtistCtrl'
    });

    $routeProvider.when('/:artist_name/:album_name', {
        templateUrl: function(params){ return '/' + params.artist_name +'/' + params.album_name + '?angular=true'; },
        controller: 'AlbumCtrl'
    });
//    $routeProvider.otherwise({ redirectTo: '/list' });
});

app.directive('showtab', function () {
    return {
        link: function (scope, element, attrs) {
            element.click(function(e) {
                e.preventDefault();
                $(element).tab('show');
            });
        }
    };
});

$('#suggest_input').typeahead(null,
    {
        name: 'artists',
        displayKey: 'name',
        source: function(query, cb){
            $.get('http://ws.audioscrobbler.com/2.0/?method=artist.search&limit=5&artist=' + query + '&api_key=99a3723ef564b7395271af5fd39dad6a&format=json', function(data) {
                cb(data.results.artistmatches.artist);
            });
        },
        templates: {
            header: '<h3 class="league-name">Artistas</h3>',
            suggestion: function(data){
                return '<a href="#/'+data.name+'"><img src="'+data.image[0]["#text"]+'" /><span>' + data.name + '</span></a>';
            }
        }
    },
    {
        name: 'albums',
        displayKey: 'name',
        source: function(query, cb){
            $.get('http://ws.audioscrobbler.com/2.0/?method=album.search&limit=5&album=' + query + '&api_key=99a3723ef564b7395271af5fd39dad6a&format=json', function(data) {
                cb(data.results.albummatches.album);
            });
        },
        templates: {
            header: '<h3 class="league-name">Albums</h3>',
            suggestion: function(data){
                return '<a href="#/'+data.artist+'/'+data.name+'" remove><i mg src="'+data.image[0]["#text"]+'" /><span>' + data.name + '</span></a>';
            }
        }
    },
    {
        name: 'tracks',
            displayKey: 'name',
        source: function(query, cb){
        $.get('http://ws.audioscrobbler.com/2.0/?method=track.search&limit=5&track=' + query + '&api_key=99a3723ef564b7395271af5fd39dad6a&format=json', function(data) {
            cb(data.results.trackmatches.track);
        });
    },
        templates: {
            header: '<h3 class="league-name">Músicas</h3>',
                suggestion: function(data){
                    return '<a href="#/'+data.artist+'/'+data.name+'"><i mg src="'+data.image[0]["#text"]+'" /><span>' + data.name + '</span></a>';
                }
        }
    }

);