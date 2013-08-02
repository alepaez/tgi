ContactRouter = Backbone.Router.extend

  initialize: ->
    app.routes['contact#index'] = 'contacts'
    app.routes['contact#new'] = 'contacts/new'
    app.routes['contact#edit'] = 'contacts/:id/edit'

  routes:
    "contacts"  : "index"
    "contacts/" : "index"
    "contacts/new" : "new"
    "contacts/:id/edit" : "edit"

  index: ->
    Events.trigger "navigation:go", "contact"
    app.rootWindow.pushRootView new ContactIndex

  new: ->
    Events.trigger "navigation:go", "contact"
    app.rootWindow.pushRootView new ContactEdit

  edit: (id) ->
    Events.trigger "navigation:go", "contact"
    app.rootWindow.pushRootView new ContactEdit {id: id}


$ ->
  app.registerRouter( ContactRouter )
