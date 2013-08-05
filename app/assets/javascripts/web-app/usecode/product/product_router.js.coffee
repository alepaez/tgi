ProductRouter = Backbone.Router.extend

  initialize: ->
    app.routes['product#index'] = 'products'
    app.routes['product#new'] = 'products/new'
    app.routes['product#edit'] = 'products/:id/edit'

  routes:
    "products"  : "index"
    "products/" : "index"
    "products/new" : "new"
    "products/:id/edit" : "edit"

  index: ->
    Events.trigger "navigation:go", "product"
    app.rootWindow.pushRootView new ProductIndex

  new: ->
    Events.trigger "navigation:go", "product"
    app.rootWindow.pushRootView new ProductEdit

  edit: (id) ->
    Events.trigger "navigation:go", "product"
    app.rootWindow.pushRootView new ProductEdit {id: id}


$ ->
  app.registerRouter( ProductRouter )
