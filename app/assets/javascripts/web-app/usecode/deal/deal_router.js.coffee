DealRouter = Backbone.Router.extend

  initialize: ->
    app.routes['deal#index'] = 'deals'
    app.routes['deal#new'] = 'deals/new'

  routes:
    "deals"  : "index"
    "deals/new" : "new"

  index: ->
    Events.trigger "navigation:go", "deal"
    app.rootWindow.pushRootView new DealIndex

  new: ->
    Events.trigger "navigation:go", "deal"
    app.rootWindow.pushRootView new DealEdit

$ ->
  app.registerRouter( DealRouter )
