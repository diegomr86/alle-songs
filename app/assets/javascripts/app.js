var app = angular.module('allesongs', ['ngResource', 'ngRoute', 'ngSanitize', 'ngCookies', 'ngDraggable', 'ui.bootstrap', 'willPaginate', 'xeditable', 'Devise'])

app.factory('Playlist', ['$resource', function($resource) {
    return $resource('/api/playlists/:id', { id: '@id' },        {
        'update': { method:'PUT' }
    });
}]);

app.run(function($rootScope, editableOptions) {
    editableOptions.theme = 'bs3'; // bootstrap3 theme. Can be also 'bs2', 'default'
    $rootScope.alert = new Alert

});


app.controller('MainCtrl', ['$scope', '$resource', '$http', '$cookieStore', 'Playlist', 'Auth', function($scope, $resource, $http, $cookieStore, Playlist, Auth) {

    var Playitem = $resource('/api/playitems/:id');

    $scope.go = function ( paths ) {
        path = '/#'
        angular.forEach(paths, function(p) {
            path += "/"+ p.replace("&", "e").replace("/", " ").replace('.', ' ')
        });

        path = encodeURI(path)
        console.log(path)
        location.href =  path ;
    };

    $scope.play = function(playitem) {
        if (playitem != undefined)
            $scope.current_playitem = playitem;
        else if ($scope.playitems[0] != undefined)
            $scope.current_playitem = $scope.playitems[0];
    }

    $scope.loadCurrentPlaylist = function(playlist) {
        $scope.current_playlist = playlist
        Playitem.query({playlist_id: playlist.id}, function(playitems) {
            $scope.setPlayitems(playitems)
        });
    };


    $scope.loadPlaylist = function(playlist) {
        $http.get("/api/playlists/"+playlist.id+"/load.json?current_playlist="+$scope.current_playlist.id).success(function (playitems) {
            $scope.setPlayitems(playitems)
        }).error(function (data) {
            console.log('error: ' + data);
        });
    };

    $scope.setPlayitems = function(playitems) {
        $scope.playitems = playitems
        $cookieStore.put("current_playlist", $scope.current_playlist);
        if ($scope.playitems.length > 0) {
            $scope.play($scope.playitems[0])
        }
    };

    $scope.savePlaylist = function(data) {
        var playlist = new Playitem({ name: data });
        Playlist.save({ current_playlist: $scope.current_playlist.id }, playlist, function(t) {
            $scope.playlists.push(t)
        })
        $scope.current_playlist.name = undefined

    };

    $scope.login_and = function(callback) {
        if (Auth.isAuthenticated()) {
//            callback();
        } else {
            $scope.showSignInModal();
        }
    };

    $scope.updatePlaylist = function(data) {
        Playlist.update({ name: data }, $scope.current_playlist, function(p){
            $scope.loadPlaylists()
            console.log(p)
        });

    };

    $scope.loadPlaylists = function() {
        $scope.playlists = Playlist.query();
    };

    $scope.addToPlaylist = function(t, play) {
        var playitem = new Playitem({ name: t.name, artist: (t.artist.name || t.artist), picture: (t.image ? t.image[3]['#text'] : t.picture), duration: (t.duration), playlist_id: $scope.current_playlist.id });
        Playitem.save(playitem, function(t) {
            //$scope should be accessible here
            $scope.playitems.push(t);
            setTimeout(function() {
                $("#playlist").slimScroll({ scrollTo: '10000px' });
            }, 100)
            if (play || $scope.current_playitem == undefined) {
                $scope.play(t)
            }
        })
    };

    $scope.addAlbumToPlaylist = function(a, play) {
        lastfm.album.getInfo({album: a.name, artist: (a.artist.name || a.artist)}, { success: function(data){
            angular.forEach(data.album.tracks.track, function(track, key) {
                track.image = a.image
                track.picture = a.picture
                $scope.addToPlaylist(track, (key == 0 && play))
            });

            $scope.$digest()
        }});
    };

    $scope.addArtistToPlaylist = function(a, play) {
        lastfm.artist.getTopTracks({artist: a.name}, { success: function(data){
            angular.forEach(data.toptracks.track, function(track, key) {
                $scope.addToPlaylist(track, (key == 1 && play))
            });

            $scope.$digest()
        }});
    };

    $scope.clearPlaylist = function() {
        angular.forEach($scope.playitems, function(playitem, key) {
            $scope.removeFromPlaylist(playitem)
        });
    };

    $scope.removePlaylist = function(playlist) {
        Playlist.delete({ id: playlist.id }, function() {
            $scope.playlists.splice($scope.playlists.indexOf(playlist), 1);
        });
    };

    $scope.removeFromPlaylist = function(playitem) {
        Playitem.delete({ id: playitem.id }, function() {
            $scope.playitems.splice($scope.playitems.indexOf(playitem), 1);
        });
    };



    $scope.setError = function (playitem) {
        console.log('error...')
        console.log(playitem)
    }

    $scope.loadNext = function () {
        if ($scope.playitems.length > 1) {
            var next = $scope.playitems.indexOf($scope.current_playitem) + 1
            if ($scope.playitems[next] != undefined) {
                $scope.play($scope.playitems[next])
            } else {
                $scope.play($scope.playitems[0])
            }

        }
    }

    $scope.loadPrevious = function () {
        if ($scope.playitems.length > 1) {
            var previous = $scope.playitems.indexOf($scope.current_playitem) - 1
            console.log(previous)
            if (previous >= 0) {
                $scope.play($scope.playitems[previous])
            } else {
                $scope.play($scope.playitems[$scope.playitems.length - 1])
            }

        }
    }

    $scope.displayVideoMeta = function (playitem, data) {

        if (data != 'undefined') {

            artist = playitem.artist;
            subtitle = playitem.name;
            title = artist + ' - ' + subtitle;

            $('title').text(title);

            lyric = ''
            translation_text = ''

//            if (data.info && data.info.mus && data.info.type == "exact") {
//                lyric = data.info.mus[0].text;
//                lyric += '<br/><br/><p><a style="font-size:10px;color:#000;text-decoration:none;font-weight:bold" target=_blank href="'+data.info.mus[0].url+'"><img src="http://www.vagalume.com.br/images/logo_small2.jpg" alt="Vagalume"><br/>Letras de Músicas</a></p>'
//
//                if (data.info.mus[0].translate) {
//                    translation_text = data.info.mus[0].translate[0].text.replace('[', '<b>').replace(']', '</b>');
//                }
//
//
//            } else {
//                lyric = "Letra não encontrada";
//            }

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
            $scope.loadNext();
        }
    }

    $scope.loadTags = function () {
        lastfm.tag.getTopTags({success: function(data){
            $scope.toptags = data.toptags.tag
            $scope.$digest()
        }});
    }

    $scope.onDropComplete=function(data,evt){
        console.log("drop success, data:", data);
        if (data.artist == undefined) {
            $scope.addArtistToPlaylist(data)
        } else if (data.duration == undefined){
            $scope.addAlbumToPlaylist(data)
        } else {
            $scope.addToPlaylist(data)
        }
    }

    $scope.showSignInModal=function(){
        $('#signin_modal').modal('show')
    }

    $scope.hideSignInModal=function(){
        $('#signin_modal').modal('hide')
    }


    $scope.setCurrentUser = function(current_user) {
        $scope.current_user = current_user
        console.log('Current user changed to: ')
        console.log($scope.current_user)
        if ($scope.current_user != undefined) {
            $scope.loadPlaylists()
            $scope.hideSignInModal()
        }
    };

    $scope.$watch('current_playitem', function(current_playitem, old_playitem) {
        if (current_playitem != undefined) {
            $.getJSON(current_playitem.url, function (data) {
                $scope.displayVideoMeta(current_playitem, data);
                if (data.video) {
                    if (typeof player == "undefined")
                        player = $scope.renderPlayer(data.video);
                    else
                        player.loadVideoById(data.video);

                    if ($scope.is_iPhone) {
                        window.scrollTo(0, 0);
                    }
                } else {
                    $scope.setError(current_playitem);
                }
            });
        }
    });

    $scope.$watch('playing', function(current_playitem, old_playitem) {
        console.log('Now playing: '+current_playitem)
    });


    // RUN
    Auth.currentUser().then(function(user) {
        console.log(user);
        $scope.setCurrentUser(user.data)
    }, function(error) {
        console.log("User not authenticated: "+error);
        $scope.showSignInModal();
    });

    if ($cookieStore.get("current_playlist") != undefined) {
        $scope.loadCurrentPlaylist($cookieStore.get("current_playlist"));
    } else {
        $http.get("/api/playlists/default.json").success(function (data) {
            $scope.loadCurrentPlaylist(data);
        }).error(function (data) {
            console.log('error: ' + data);
        });
    }
    $scope.loadTags()



    $('#suggest_input').bind('typeahead:selected', function(obj, datum, name) {
        if (name == 'artists') {
            $scope.go([datum.name])
        } else if (name == 'albums') {
            $scope.go([datum.artist, datum.name])
        }  else if (name == 'tracks') {
            $scope.addToPlaylist(datum,  true)
        } else if (name == 'tags') {
            $scope.go(["tag", datum.name])
        }

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
                header: '<h4 class="tt-header">Artistas</h4>',
                suggestion: function(data){
                    return '<p><a><img src="'+(data.image ? data.image[0]["#text"] : '')+'" /><strong>' + data.name + '</strong></a><p>';
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
                header: '<h4 class="tt-header">Albums</h4>',
                suggestion: function(data){
                    return '<p><a><img src="'+(data.image ? data.image[0]["#text"] : '')+'" /><strong>' + data.name + '</strong> - <span>' + data.artist + '</span></a><p>';
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
                header: '<h4 class="tt-header">Músicas</h4>',
                suggestion: function(data){
                    return '<p><a><img src="'+(data.image ? data.image[0]["#text"] : '')+'" /><strong>' + data.name + '</strong> - <span>' + data.artist + '</span></a> <p>';
                }
            }
        },
        {
            name: 'tags',
            displayKey: 'name',
            source: function(query, cb){
                $.get('http://ws.audioscrobbler.com/2.0/?method=tag.search&limit=5&tag=' + query + '&api_key=99a3723ef564b7395271af5fd39dad6a&format=json', function(data) {
                    cb(data.results.tagmatches.tag);
                });
            },
            templates: {
                header: '<h4 class="tt-header">Tags</h4>',
                suggestion: function(data){
                    return '<p><a><strong>' + data.name + '</strong></a> <p>';
                }
            }
        }

    );
}]);

app.controller('ArtistCtrl', ['$scope', '$routeParams', function($scope, $routeParams) {
    lastfm.artist.getInfo({artist: $routeParams.artist_name}, {success: function(data){
        $scope.artist = data.artist
        $scope.$digest()

        lastfm.artist.getTopAlbums({artist: $scope.artist.name}, {success: function(data){
            $scope.artist.top_albums = data.topalbums.album
            $scope.$digest()
        }});
    }});

    $scope.load_top_tracks = function () {
        if (!$scope.artist.top_tracks) {
            lastfm.artist.getTopTracks({artist: $scope.artist.name}, {success: function (data) {
                $scope.artist.top_tracks = data.toptracks.track
                $scope.$digest()
            }});
        }
    }

    $scope.load_events = function () {
        if (!$scope.artist.events) {
            lastfm.artist.getEvents({artist: $scope.artist.name}, {success: function(data){
                $scope.artist.events = data.events.event
                $scope.$digest()
            }});
        }
    }

    if ($scope.playitems[0]) {
        $scope.play($scope.playitems[0])
    }



}]);

app.controller('AlbumCtrl', ['$scope', '$resource', function($scope, $resource) {

}]);

app.controller('SignInCtrl', ['$scope', '$resource', 'Auth', function($scope, $resource, Auth) {
    $scope.user = {};

    $scope.signin = function(user) {
        Auth.login(user).then(function(currentUser) {
            $scope.setCurrentUser(currentUser);
        }, function(error) {
            angular.forEach(error.data.errors, function(error) {
                $scope.alert.add(error, { container: "signin-errors", auto_close: 3 });
            });
            console.log("Authentication failed: ");
            console.log(error);
        });
    };

    $scope.signup = function(user) {
        Auth.register(user).then(function(currentUser) {
            $scope.setCurrentUser(currentUser);
        }, function(error) {
            angular.forEach(error.data.errors, function(error, key) {
                $scope.alert.add(key+" "+error, { container: "signup-errors", auto_close: 3 });
            });
            console.log("Registration failed: ");
            console.log(error);
        });
    };

    $scope.$on('devise:login', function(event, currentUser) {
        if (Auth.isAuthenticated()) {
            $scope.setCurrentUser(currentUser);
        }
    });

    $scope.$on('devise:new-registration', function(event, user) {

    });

}]);

app.controller('TopCtrl', ['$scope', '$resource', function($scope, $resource) {

    var Artist = $resource('/api/artists/:id');
    var Album = $resource('/api/albums/:id');
    var Track = $resource('/api/tracks/:id');

    $scope.top_artists = Artist.query();
    $scope.top_albums = Album.query();
    $scope.top_tracks = Track.query();

}]);

app.controller('TagCtrl', ['$scope', '$routeParams', function($scope, $routeParams) {

    $scope.tag = { name: $routeParams.tag_name }

    lastfm.tag.getTopArtists({ tag: $routeParams.tag_name, limit: 12 }, { success: function(data){
        $scope.tag.top_artists = data.topartists.artist
        $scope.$digest()
    }});

    lastfm.tag.getTopAlbums({ tag: $routeParams.tag_name, limit: 12 }, { success: function(data){
        $scope.tag.top_albums = data.topalbums.album
        $scope.$digest()
    }});

    lastfm.tag.getTopTracks({ tag: $routeParams.tag_name, limit: 12 }, { success: function(data){
        $scope.tag.top_tracks = data.toptracks.track
        $scope.$digest()
    }});

}]);


app.config(function($routeProvider, $locationProvider) {

    init.push(function () {

//        window.PixelAdmin.plugins.alerts.add('asdfasdf', {auto_close: 3});


    } );
    window.PixelAdmin.start(init);



    $routeProvider.when('/top', {
        templateUrl: function(){ return '/top?angular=true'; },
        controller: 'TopCtrl'
    });

    $routeProvider.when('/:tag/:tag_name', {
        templateUrl: function(params){ return '/tag/' + params.tag_name + '?angular=true'; },
        controller: 'TagCtrl'
    });

    $routeProvider.when('/:artist_name', {
        templateUrl: function(params){ return '/' + params.artist_name + '?angular=true'; },
        controller: 'ArtistCtrl'
    });

    $routeProvider.when('/:artist_name/:album_name', {
        templateUrl: function(params){ return '/' + params.artist_name +'/' + params.album_name + '?angular=true'; },
        controller: 'AlbumCtrl'
    });

    $routeProvider.otherwise({ redirectTo: '/top' });
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

app.filter('html_filter', function($sce) {
    return function(val) {
        return $sce.trustAsHtml(val.split('http://www.last.fm/music/').join('/#/').split('http://www.last.fm/tag/').join('/#/tag/').split('+').join(' ').split('Last.fm').join('AlleSongs.com'));
    };
});

app.filter("int_to_date", function () {
    return function (input) {

        var hours = Math.floor(input / 3600);
        var minutes = Math.floor((input - (hours * 3600))/60);
        var seconds = input - (hours * 3600) - (minutes * 60);

        while (minutes.length < 2) {minutes = '0' + minutes;}
        while (seconds.length < 2) {seconds = '0' + minutes;}

        return new Date(0, 0, 0, hours, minutes, seconds, 0)
    }
});

app.directive('facebook', function($http) {
    return {
        restrict: 'A',
        scope: true,
        controller: function($scope, $attrs) {
            // Load the SDK Asynchronously
            (function(d){
                var js, id = 'facebook-jssdk', ref = d.getElementsByTagName('script')[0];
                if (d.getElementById(id)) {return;}
                js = d.createElement('script'); js.id = id; js.async = true;
                js.src = "//connect.facebook.net/en_US/all.js";
                ref.parentNode.insertBefore(js, ref);
            }(document));

            function login() {
                FB.login(function(response) {
                        if (response.authResponse) {
                            console.log('FB.login connected');
                            fetch();
                        } else {
                            console.log('FB.login cancelled');
                        }
                    }, { scope: 'email,read_stream' }
                );
            };

            function fetch() {
                console.log('1')
                FB.getLoginStatus(function (response) {
                    console.log('2')
                    if (response.status === 'connected') {
                        console.log('3')
                        $scope.auth = response.authResponse;
                        $http.get("/users/auth/facebook/callback?access_token=" + $scope.auth.accessToken, {  }).success(function (data) {
                            $scope.setCurrentUser(data);
                        }).error(function (data) {
                            console.log('error: ' + data);
                        });

                    } else if (response.status === 'not_authorized') {
                        console.log('not_authorized')
                    } else {
                        console.log('not_logged_in')
                    }
                });
            }

            $scope.fetch = function() {
                if ($scope.login_status == 'connected') {
                    fetch();
                } else {
                    login();
                }
            };
        },
        link: function(scope, element, attrs, controller) {
            // Additional JS functions here
            window.fbAsyncInit = function() {
                FB.init({
                    appId      : attrs.facebook, // App ID
                    channelUrl : '//localhost:3000/channel.html', // Channel File
                    status     : true, // check login status
                    cookie     : true, // enable cookies to allow the server to access the session
                    xfbml      : true  // parse XFBML
                });
            }; // end of fbAsyncInit
        }
    }
});
