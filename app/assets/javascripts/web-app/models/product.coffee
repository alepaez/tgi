class window.app.Product extends window.app.BaseResource
  identifier: "product"
  urlRoot: api_base + 'products'

  collection: window.app.Products

  initialize: ->
    super

class window.app.Products extends window.app.BaseResources
  model: window.app.Product

  paginator_core:
    url: api_base + 'products?&'
    dataType: 'json'
