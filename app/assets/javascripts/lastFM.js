/* Create a cache object */
var cache = new LastFMCache();

/* Create a LastFM object */
var lastfm = new LastFM({
    apiKey    : '534b78cd8e40fe67e31b50b9693ae512',
    apiSecret : 'abc7b7049ad4e653783023075ca14e73',
    cache     : cache
});

