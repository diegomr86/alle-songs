class Music.Models.Track extends Backbone.Model
  paramRoot: 'track'

  defaults:
    track: null
    artist: null
    session_id: null

class Music.Collections.TracksCollection extends Backbone.Collection
  model: Music.Models.Track
  url: '/tracks'
