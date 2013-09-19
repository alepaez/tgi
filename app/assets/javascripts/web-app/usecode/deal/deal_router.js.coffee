DealRouter = Backbone.Router.extend

  initialize: ->
    app.routes['deal#index'] = 'deals'
    app.routes['deal#show'] = 'deals/:id'
    app.routes['deal#new'] = 'deals/new'
    app.routes['deal#edit'] = 'deals/:id/edit'

  routes:
    "deals"  : "index"
    "deals/:id"  : "show"
    "deals/new" : "new"
    "deals/:id/edit"  : "edit"

  index: ->
    Events.trigger "navigation:go", "deal"
    app.rootWindow.pushRootView new DealIndex

  new: ->
    Events.trigger "navigation:go", "deal"
    app.rootWindow.pushRootView new DealEdit

  edit: (id) ->
    Events.trigger "navigation:go", "deal"
    app.rootWindow.pushRootView new DealEdit {id: id}

  show: (id) ->
    Events.trigger "navigation:go", "deal"
    app.rootWindow.pushRootView new DealShow {id: id}

$ ->
  app.registerRouter( DealRouter )
