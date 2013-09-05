class window.app.Deal extends window.app.BaseResource
  identifier: "deal"
  urlRoot: api_base + 'deals'

  collection: window.app.Deals

  initialize: ->
    super

class window.app.Deals extends window.app.BaseResources
  model: window.app.Deal

  paginator_core:
    url: api_base + 'deals?&'
    dataType: 'json'
