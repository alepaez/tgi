DealRouter = Backbone.Router.extend

  initialize: ->
    app.routes['deal#index'] = 'deals'

  routes:
    "deals"  : "index"

  index: ->
    Events.trigger "navigation:go", "deal"
    app.rootWindow.pushRootView new DealIndex

$ ->
  app.registerRouter( DealRouter )
