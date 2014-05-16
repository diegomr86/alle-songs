Music.Views.Tracks ||= {}

class Music.Views.Tracks.IndexView extends Backbone.View
  template: JST["backbone/templates/tracks/index"]

  initialize: () ->
    @collection.bind('reset', @addAll)

  addAll: () =>
    @collection.each(@addOne)

  addOne: (track) =>
    view = new Music.Views.Tracks.TrackView({model : track})
    @$("tbody").append(view.render().el)

  render: =>
    @$el.html(@template(tracks: @collection.toJSON() ))
    @addAll()

    return this
