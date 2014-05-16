class Music.Routers.TracksRouter extends Backbone.Router
  initialize: (options) ->
    @tracks = new Music.Collections.TracksCollection()
    @tracks.reset options.tracks

  routes:
    "new"      : "newTrack"
    "index"    : "index"
    ":id/edit" : "edit"
    ":id"      : "show"
    ".*"        : "index"

  newTrack: ->
    @view = new Music.Views.Tracks.NewView(collection: @tracks)
    $("#tracks").html(@view.render().el)

  index: ->
    @view = new Music.Views.Tracks.IndexView(collection: @tracks)
    $("#tracks").html(@view.render().el)

  show: (id) ->
    track = @tracks.get(id)

    @view = new Music.Views.Tracks.ShowView(model: track)
    $("#tracks").html(@view.render().el)

  edit: (id) ->
    track = @tracks.get(id)

    @view = new Music.Views.Tracks.EditView(model: track)
    $("#tracks").html(@view.render().el)
