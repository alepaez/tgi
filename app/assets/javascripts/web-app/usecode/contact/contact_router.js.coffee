ContactRouter = Backbone.Router.extend

  initialize: ->
    app.routes['contact#index'] = 'contacts'

  routes:
    "contacts"  : "index"
    "contacts/" : "index"

  index: ->
    debug "aqui tb tio"
    Events.trigger "navigation:go", "contact"
    app.rootWindow.pushRootView new ContactIndex

$ ->
  app.registerRouter( ContactRouter )
